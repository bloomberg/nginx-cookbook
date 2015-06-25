# Cookbook: nginx-cookbook
# License: Apache 2.0
#
# Copyright (C) 2015 Bloomberg Finance L.P.
require 'poise'
require_relative 'helpers'

class Chef::Resource::NginxSite < Chef::Resource
  include Poise(fused: true)
  provides(:nginx_site)
  include NginxCookbook::Helpers

  actions(:enable, :delete)
  default_action(:enable)

  # @!attribute instance
  # @return [String]
  attribute(:instance, name_attribute: true)

  # @!attribute source
  # @return [String]
  attribute(:source, kind_of: String, default: 'default-site.erb')

  # @initial settings for functioning site
  attribute(:servername, kind_of: [String, NilClass], default: nil)
  attribute(:port, kind_of: Integer, default: '80')
  attribute(:root_location, kind_of: String, default: '/var/www')
  attribute(:location, kind_of: String, default: '/')
  attribute(:additional_options, option_collector: true)

  # @!attribute enable_ssl
  # @return [TrueClass ,FalseClass]
  attribute(:ssl_enable, kind_of: [TrueClass, FalseClass], default: false)
  attribute(:force_ssl_redirect, kind_of: [TrueClass, FalseClass], default: false)
  attribute(:ssl_port, kind_of: Integer, default: '443')
  attribute(:ssl_cert, kind_of: [String, NilClass], default: nil)
  attribute(:ssl_key, kind_of: [String, NilClass], default: nil)
  attribute(:ssl_session_timeout, kind_of: Integer, default: "5m")
  attribute(:ssl_protocols, kind_of: String, default: "SSLv3 TLSv1 TLSv1.1 TLSv1.2")
  attribute(:ssl_ciphers, kind_of: String, default: "HIGH:!aNULL:!MD5 or HIGH:!aNULL:!MD5:!3DES")
  attribute(:ssl_prefer_server_ciphers, equal_to: %w{yes no}, default: 'yes')
  attribute(:additional_ssl_options, option_collector: true)

  # @!attribute variables
  # @return [String]
  attribute(:cookbook, kind_of: String, default: 'nginx')

  # Setup site config files for nginx
  action(:enable) do
    notifying_block do
      %w(sites-enabled sites-available ssl).each do |d|
        directory "#{new_resource.instance} :create /etc/nginx/#{d}" do
          path "/etc/nginx/#{d}"
          owner "root"
          group "root"
          mode "0755"
          recursive true
          action :create
        end
      end

      file "/etc/nginx/sites-enabled/default" do
        action :delete
      end

      template "#{new_resource.instance} :create /etc/nginx/sites-available/#{new_resource.instance}" do
        path "/etc/nginx/sites-available/#{new_resource.instance}"
        source new_resource.source
        variables(
          config: new_resource,
          servername: new_resource.servername,
          port:  new_resource.port,
          root_location: new_resource.root_location, 
          access_log: "/var/log/nginx/#{new_resource.servername}_access.log",
          error_log: "/var/log/nginx/#{new_resource.servername}_error.log"
        )
          owner "root"
          group "root"
          mode "0644"
          cookbook "nginx"
      end

      link "#{new_resource.instance} :enable /etc/nginx/sites-enabled/#{new_resource.instance}" do
        target_file "/etc/nginx/sites-enabled/#{new_resource.instance}"
        to "/etc/nginx/sites-available/#{new_resource.instance}"
        action :create
      end
    end
  end

  action(:delete) do
    notifying_block do
      file "#{new_resource.name} :delete /etc/nginx/sites-available/#{new_resource.name}" do
        path "/etc/nginx/sites-available/#{new_resource.name}"
        action :delete
      end

      link "#{new_resource.name} :disable /etc/nginx/sites-enabled/#{new_resource.name}" do
        target_file "/etc/nginx/sites-enabled/#{new_resource.name}"
        action :delete
      end
    end
  end
end

#
# Cookbook: nginx-cookbook
# License: Apache 2.0
#
# Copyright (C) 2015 Bloomberg Finance L.P.
require 'poise_service/service_mixin'
require_relative 'helpers'

class Chef::Resource::NginxService < Chef::Resource
  include Poise
  provides(:nginx_service)
  include PoiseService::ServiceMixin

  actions(:enable, :disable)
  default_action(:enable)

  # @!attribute instance
  # @return [String]
  attribute(:instance, kind_of: [String, NilClass], default: nil)

  # @!attribute cookbook
  # @return [String]
  attribute(:cookbook, kind_of: [String], default: 'nginx')

  # @!attribute package
  # @return [String]
  attribute(:pkg, kind_of: String, default: 'nginx')

  # @!attribute version
  # @return [String, NilClass]
  attribute(:version, kind_of: [String, NilClass], default: nil)

  # !@attribute config_dir
  # @return [String]
  attribute(:config_dir, kind_of: String, default: '/etc/nginx')

  # @see: default nginx.conf configuration file
  attribute(:source, kind_of: String, default: 'nginx.conf.erb')
  attribute(:worker_processes, kind_of: Integer, default: 4)
  attribute(:pid_file, kind_of: String, default: '/run/nginx/nginx.pid')
  attribute(:worker_connections, kind_of: Integer, default: '1024')
  attribute(:sendfile, equal_to: %w{on off}, default: 'on')
  attribute(:tcp_nopush, equal_to: %w{on off}, default: 'on')
  attribute(:tcp_nodelay, equal_to: %w{on off}, default: 'on')
  attribute(:keepalive_timeout, kind_of: Integer, default: '65')
  attribute(:types_hash_max_size, kind_of: Integer, default: '2048')
  attribute(:server_tokens, equal_to: %w{on off}, default: nil)
  attribute(:server_names_hash_bucket_size, kind_of: [Integer, NilClass], default: nil)
  attribute(:server_name_in_redirect, equal_to: %w{on off}, default: nil)
  attribute(:log_path, kind_of: String, default: '/var/log/nginx')
  attribute(:access_log, kind_of: String, default: 'access.log')
  attribute(:error_log, kind_of: String, default: 'error.log')
  attribute(:gzip, equal_to: %w{on off}, default: 'on')
  attribute(:gzip_disable, kind_of: String, default: 'msie6')
  attribute(:gzip_vary, equal_to: %w{on off}, default: nil)
  attribute(:gzip_proxied, kind_of: [String, NilClass], default: nil)
  attribute(:gzip_comp_level, kind_of: [Integer, NilClass], default: nil)
  attribute(:gzip_buffers, kind_of: [String, NilClass], default: nil)
  attribute(:gzip_http_version, kind_of: [String, NilClass], default: nil)
  attribute(:gzip_types, kind_of: [String, NilClass], default: nil)

  # !@attribute additional_options
  # @return [Hash]
  attribute(:additional_options, option_collector: true)
end

class Chef::Provider::NginxService < Chef::Provider
  include Poise
  provides(:nginx_service)
  include PoiseService::ServiceMixin
  include NginxCookbook::Helpers

  # Setup intial service files for nginx
  def action_enable
    notifying_block do
      # Install Packages
      package new_resource.pkg do
        package_name new_resource.pkg
        version new_resource.version unless new_resource.version.nil?
        action :upgrade
      end

      # Create supporting directories
      directory "#{new_resource.instance} :create #{new_resource.log_path}" do
        path new_resource.log_path
        recursive true
        owner platform_user
        group platform_user
        mode 0755
        action :create
      end

      # Create pid dir
      directory '/run/nginx' do
        owner platform_user
        group platform_user
        mode 0755
        action :create
      end

      # Create primary nginx directory
      directory "#{new_resource.instance} :create #{new_resource.config_dir}" do
        path new_resource.config_dir
        owner 'root'
        group 'root'
        mode 0755
        action :create
      end

      # Create additional directories
      %w(conf.d sites-available sites-enabled modules).each do |dir|
        directory "#{new_resource.instance} :create #{new_resource.config_dir}/#{dir}" do
          path "#{new_resource.config_dir}/#{dir}"
          owner 'root'
          group 'root'
          mode 0755
          action :create
        end
      end

      template "#{new_resource.instance} :create #{new_resource.config_dir}/nginx.conf" do
        path "#{new_resource.config_dir}/nginx.conf"
        source new_resource.source
        owner 'root'
        group 'root'
        cookbook new_resource.cookbook
        variables(
          config: new_resource,
          user: platform_user
        )
        action :create
      end
    end
    super
  end

  def service_options(service)
    service.service_name('nginx')
    service.command('/usr/sbin/nginx')
    service.directory('/run/nginx')
    service.environment('PID' => '/run/nginx/nginx.pid')
    service.user(platform_user)
    service.restart_on_update(true)
    service.options :systemd, template: 'nginx:systemd.erb'
    service.options :upstart, template: 'nginx:upstart.erb'
  end
end

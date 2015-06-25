# Cookbook: nginx-cookbook
# License: Apache 2.0
#
# Copyright (C) 2015 Bloomberg Finance L.P.
require 'poise'
require_relative 'helpers'

class Chef::Resource::NginxSite < Chef::Resource
  include Poise(fused: true)
  provides(:nginx_module)
  include NginxCookbook::Helpers

  actions(:create, :delete)

  # @!attribute instance
  # @return [String]
  attribute(:module_name, name_attribute: true)

  # @!attribute source
  # @return [String]
  attribute(:source, kind_of: String, default: 'default-site.erb')

  # @!attribute config_options
  # @return [Hash]
  attribute(:module_config, kind_of: Hash, default: {})

  # @!attribute cookbook
  # @return [String]
  attribute(:cookbook, kind_of: String, default: 'nginx')

  # Setup site config files for nginx
  action(:create) do
    notifying_block do
      template "#{new_resource.module_name} :create /etc/nginx/modules/#{new_resource.module_name}" do
        path "/etc/nginx/modules/#{new_resource.module_name}"
        source new_resource.source
        variables(
          module_config: new_resource.module_config,
        )
        owner "root"
        group "root"
        mode "0644"
        cookbook new_resource.cookbook
      end
    end
  end

  action(:delete) do
    notifying_block do
      file "#{new_resource.instance} :delete /etc/nginx/sites-available/#{new_resource.instance}" do
        path "/etc/nginx/modules/#{new_resource.instance}"
        action :delete
      end
    end
  end
end

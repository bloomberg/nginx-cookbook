# Cookbook: nginx-cookbook
# License: Apache 2.0
#
# Copyright (C) 2015 Bloomberg Finance L.P.
require 'poise'
require_relative 'helpers'

class Chef::Resource::NginxModule < Chef::Resource
  include Poise(fused: true)
  provides(:nginx_module)
  include NginxCookbook::Helpers

  actions(:create, :delete)

  # @!attribute instance
  # @return [String]
  attribute(:module_name, name_attribute: true)

  # @!attribute source
  # @return [String]
  attribute(:source, kind_of: String, default: 'module.conf.erb')

  # @!attribute config_options
  # @return [Hash]
  attribute(:module_config, options_collector: true)

  # @!attribute cookbook
  # @return [String]
  attribute(:cookbook, kind_of: String, default: 'nginx')

  # !@attribute user
  # @return [String]
  attribute(:user, kind_of: String, default: 'root')

  # !@attribute group
  # @return [String]
  attribute(:group, kind_of: String, default: 'root')

  # Setup site config files for nginx
  action(:create) do
    notifying_block do
      template "#{new_resource.module_name} :create /etc/nginx/modules/#{new_resource.module_name}" do
        path "/etc/nginx/modules/#{new_resource.module_name}"
        source new_resource.source
        owner new_resource.user
        group new_resource.group
        mode 0644
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

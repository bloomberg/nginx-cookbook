module NginxCookbook
  module Helpers
    # Set default hostname to server hostname
    def parsed_servername
      return new_resource.servername if new_resource.servername
      node.hostname
    end

    def platform_user
      case node.platform_family
      when 'debian', 'ubuntu'
        'www-data'
      else
        'nginx'
      end
    end
  end
end

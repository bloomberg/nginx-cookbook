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

    def setup_repository
      case node.platform
      when 'centos', 'rhel'

        file '/etc/yum.repos.d/nginx.repo' do
          owner 'root'
          group 'root'
          mode 0644
          action :create
        end

        bash 'add nginx repo source' do
          code <<-EOH
            echo '[nginx]' | sudo tee /etc/yum.repos.d/nginx.repo
            echo 'name=nginx repo' | sudo tee -a /etc/yum.repos.d/nginx.repo
            echo 'baseurl=http://nginx.org/packages/#{node.platform}/$releasever/$basearch/' | sudo tee -a /etc/yum.repos.d/nginx.repo
            echo 'gpgcheck=0' | sudo tee -a /etc/yum.repos.d/nginx.repo
            echo 'enabled=1' | sudo tee -a /etc/yum.repos.d/nginx.repo
          EOH
          action :run
        end
      end
    end
  end
end

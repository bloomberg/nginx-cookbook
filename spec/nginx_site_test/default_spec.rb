require 'spec_helper'

describe 'nginx-integration-test::default' do
  let(:chef_run) do
    ChefSpec::Runner.new(
      step_into: 'nginx_site'
    ).converge(described_recipe)
  end

  context 'when compiling the test recipe' do
    it 'creates nginx_site[www]' do
      expect(chef_run).to create_nginx_site('www')
    end

    it 'enables nginx_site[www]' do
      expect(chef_run).to enable_nginx_site('www')
    end

    it 'deletes nginx_site[default]' do
      expect(chef_run).to delete_nginx_site('default')
    end

    it 'disables nginx_site[default]' do
      expect(chef_run).to disable_nginx_site('default')
    end
  end

  context 'stepping in to nginx_site[www] :create action' do
    name_and_action = 'www :create'

    it "creates directory[#{name_and_action} /etc/nginx/sites-available" do
      expect(chef_run).to create_directory("#{name_and_action} /etc/nginx/sites-available")
        .with(
          path: '/etc/nginx/sites-available',
          owner: 'root',
          group: 'root',
          mode: 0755
        )
    end

    it "creates template[#{name_and_action} /etc/nginx/sites-available/www]" do
      expect(chef_run).to create_template("#{name_and_action} /etc/nginx/sites-available/www")
        .with(
          path: '/etc/nginx/sites-available/www.example.com',
          source: 'default-site.erb',
          variables: {
            servername: 'www.example.com'
          },
          owner: 'root',
          group: 'root',
          mode: 0644
        )
    end
  end

  context 'stepping in to nginx_site[www] :enable action' do
    name_and_action = 'www :enable'

    it "creates directory[#{name_and_action} /etc/nginx/sites-enabled" do
      expect(chef_run).to create_directory("#{name_and_action} /etc/nginx/sites-enabled")
        .with(
          path: '/etc/nginx/sites-enabled',
          owner: 'root',
          group: 'root',
          mode: 0755
        )
    end

    it "creates link[#{name_and_action} /etc/nginx/sites-enabled/www]" do
      expect(chef_run).to create_link("#{name_and_action} /etc/nginx/sites-enabled/www")
        .with(
          target_file: '/etc/nginx/sites-enabled/www',
          to: '/etc/nginx/sites-available/www'
        )
    end
  end

  context 'stepping in to nginx_site[default] :delete action' do
    name_and_action = 'default :delete'

    it "deletes file[#{name_and_action} /etc/nginx/sites-available/default]" do
      expect(chef_run).to delete_file("#{name_and_action} /etc/nginx/sites-available/default")
        .with(
          path: '/etc/nginx/sites-available/default'
        )
    end
  end

  context 'stepping in to nginx_site[default] :disable action' do
    name_and_action = 'default :disable'

    it "deletes link[#{name_and_action} /etc/nginx/sites-enabled/default]" do
      expect(chef_run).to delete_link("#{name_and_action} /etc/nginx/sites-enabled/default")
        .with(
          target_file: '/etc/nginx/sites-enabled/default'
        )
    end
  end
end

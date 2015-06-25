#require 'spec_helper'
require 'chefspec'
require 'chefspec/berkshelf'

describe "nginx_service_test::default" do
  let(:chef_run) do
    ChefSpec::Runner.new(
      step_into: ['nginx_service']
    ).converge(described_recipe)
  end

  context "compiling the test recipe" do
    it "creates nginx_service[default]" do
      expect(chef_run).to create_nginx_service('default')
    end

    it "starts nginx_service[default]" do
      expect(chef_run).to start_nginx_service('default')
    end
  end

  context "stepping in to the nginx_service[default] :create action" do
    name_and_action = "default :create"

    it "installs package[#{name_and_action} nginx]" do
      expect(chef_run).to install_package("#{name_and_action} nginx")
    end

    it "stops service[#{name_and_action} nginx]" do
      expect(chef_run).to stop_service("#{name_and_action} nginx")
    end

    it "disables service[#{name_and_action} nginx]" do
      expect(chef_run).to disable_service("#{name_and_action} nginx")
    end

    it "creates directory[#{name_and_action} /var/log/nginx]" do
      expect(chef_run).to create_directory("#{name_and_action} /var/log/nginx")
        .with(
          owner: 'www-data',
          group: 'adm',
          mode: '0755'
        )
    end

    it "creates directory[#{name_and_action} /etc/nginx]" do
      expect(chef_run).to create_directory("#{name_and_action} /etc/nginx")
        .with(
          owner: 'root',
          group: 'root',
          mode: '0755'
        )
    end

    it "creates directory[#{name_and_action} /etc/nginx/conf.d]" do
      expect(chef_run).to create_directory("#{name_and_action} /etc/nginx/conf.d")
        .with(
          owner: 'root',
          group: 'root',
          mode: '0755'
        )
    end

    it "creates directory[#{name_and_action} /etc/nginx/sites-available]" do
      expect(chef_run).to create_directory("#{name_and_action} /etc/nginx/sites-available")
        .with(
          owner: 'root',
          group: 'root',
          mode: '0755'
        )
    end

    it "creates directory[#{name_and_action} /etc/nginx/sites-enabled]" do
      expect(chef_run).to create_directory("#{name_and_action} /etc/nginx/sites-enabled")
        .with(
          owner: 'root',
          group: 'root',
          mode: '0755'
        )
    end

    it "deletes link[#{name_and_action} /etc/nginx/sites-enabled/default]" do
      expect(chef_run).to delete_link("#{name_and_action} /etc/nginx/sites-enabled/default")
    end

    it "deletes file[#{name_and_action} /etc/nginx/sites-available/default]" do
      expect(chef_run).to delete_file("#{name_and_action} /etc/nginx/sites-available/default")
    end
  end

  context "stepping in to the nginx_service[default] :start action" do
    name_and_action = "default :start"

    it "creates template[#{name_and_action} /etc/init.d/nginx]" do
      expect(chef_run).to create_template("#{name_and_action} /etc/init.d/nginx")
        .with(
          owner: 'root',
          group: 'root',
          mode: '0755'
        )
    end

    it "enables service[#{name_and_action} nginx]" do
      expect(chef_run).to enable_service("#{name_and_action} nginx")
    end

    it "starts service[#{name_and_action} nginx]" do
      expect(chef_run).to start_service("#{name_and_action} nginx")
    end
  end
end

require 'chefspec'

describe "nginx_service_test::with_default_site" do
  let(:chef_run) do
    ChefSpec::Runner.new(
      step_into: 'nginx_service'
    ).converge(described_recipe)
  end

  context "when compiling the test recipe" do
    it "manages nginx_service[default]" do
      expect(chef_run).to create_nginx_service('default')
      expect(chef_run).to start_nginx_service('default')
    end

    it "creates nginx_site[default]" do
      expect(chef_run).to create_nginx_site('default')
    end
  end

  # Purpose of this set of specs is to prove that when a nginx_site[default]
  # resource is defined as part of the run, nginx_service does not attempt to
  # delete the /etc/nginx/sites-enabled/default and
  # /etc/nginx/sites-available/default files.
  context "stepping in to nginx_service[default]" do
    it "does not delete link[/etc/nginx/sites-enabled/default]" do
      expect(chef_run).not_to delete_link('/etc/nginx/sites-enabled/default')
    end

    it "does not delete file[/etc/nginx/sites-available/default]" do
      expect(chef_run).not_to delete_file('/etc/nginx/sites-available/default')
    end
  end
end

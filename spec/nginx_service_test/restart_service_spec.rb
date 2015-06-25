describe "nginx_service_test::restart_service" do
  let(:chef_run) do
    ChefSpec::Runner.new(
      step_into: ['nginx_service']
    ).converge(described_recipe)
  end

  context "compiling the test recipe" do
    it "restarts nginx_service[default]" do
      expect(chef_run).to restart_nginx_service('default')
    end
  end

  context "stepping in to nginx_service[default] action :restart" do
    name_and_action = "default :restart"

    it "restarts service[#{name_and_action} nginx]" do
      expect(chef_run).to restart_service("#{name_and_action} nginx")
        .with(
          service_name: "nginx"
        )
    end
  end
end

describe "nginx_service_test::stop_service" do
  let(:chef_run) do
    ChefSpec::Runner.new(
      step_into: ['nginx_service']
    ).converge(described_recipe)
  end

  context "compiling the test recipe" do
    it "stops nginx_service[default]" do
      expect(chef_run).to stop_nginx_service('default')
    end
  end

  context "stepping in to nginx_service[default] action :stop" do
    name_and_action = "default :stop"

    it "stops service[#{name_and_action} nginx]" do
      expect(chef_run).to stop_service("#{name_and_action} nginx")
        .with(
          service_name: "nginx"
        )
    end
  end
end

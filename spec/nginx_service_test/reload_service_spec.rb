describe "nginx_service_test::reload_service" do
  let(:chef_run) do
    ChefSpec::Runner.new(
      step_into: ['nginx_service']
    ).converge(described_recipe)
  end

  context "compiling the test recipe" do
    it "reloads nginx_service[default]" do
      expect(chef_run).to reload_nginx_service('default')
    end
  end

  context "stepping in to nginx_service[default] action :reload" do
    name_and_action = "default :reload"

    it "reloads service[#{name_and_action} nginx]" do
      expect(chef_run).to reload_service("#{name_and_action} nginx")
        .with(
          service_name: "nginx"
        )
    end
  end
end

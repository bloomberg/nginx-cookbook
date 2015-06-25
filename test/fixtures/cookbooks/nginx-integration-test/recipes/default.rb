nginx_service "www" do
  additional_options do
    jason 'blank'
  end
end

nginx_site "www" do
  servername "www.example.com"
  notifies :restart, "nginx_service[#{instance}]", :immediately
  action [:enable]
end

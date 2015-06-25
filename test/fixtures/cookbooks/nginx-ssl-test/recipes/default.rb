nginx_service "www-ssl" do 
  action [:enable, :start]
end

nginx_site "www-ssl" do
  servername "www.example.com"
  ssl_enable true
  action [:create, :enable]
end

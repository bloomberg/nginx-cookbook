if defined?(ChefSpec)
  def create_nginx_service(name)
    ChefSpec::Matchers::ResourceMatcher.new(:nginx_service, :create, name)
  end

  def create_nginx_site(name)
    ChefSpec::Matchers::ResourceMatcher.new(:nginx_site, :create, name)
  end

  def enable_nginx_site(name)
    ChefSpec::Matchers::ResourceMatcher.new(:nginx_site, :enable, name)
  end

  def delete_nginx_site(name)
    ChefSpec::Matchers::ResourceMatcher.new(:nginx_site, :delete, name)
  end

  def disable_nginx_site(name)
    ChefSpec::Matchers::ResourceMatcher.new(:nginx_site, :disable, name)
  end
end

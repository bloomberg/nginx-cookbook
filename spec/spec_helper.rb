require 'chefspec'
require 'chefspec/berkshelf'

def set_default_node_attributes!(node)
  node.automatic['region'] = 'dev0'
  node.automatic['lsb']['codename'] = 'trusty'
end

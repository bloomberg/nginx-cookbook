maintainer       "Anthony Caiafa"
maintainer_email "acaiafa1@bloomberg.net"
description      "Installs/Configures nginx"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.1"
name             "nginx"

depends 'poise', '~> 2.0'
depends 'poise-service'

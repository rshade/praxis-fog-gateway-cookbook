name             'praxis_fog_gateway_cookbook'
maintainer       'RightScale Inc'
maintainer_email 'premium@rightscale.com'
license          'Apache 2.0'
description      'Installs/Configures praxis_fog_gateway_cookbook'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'


depends "rvm"
depends "bluepill"

recipe "praxis_fog_gateway_cookbook::default", "installs and starts praxis-fog-gateway"

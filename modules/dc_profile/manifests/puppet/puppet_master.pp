# == Class: dc_profile::puppet::puppet_master
#
# Installs a passenger based puppet master and support
# infrastructure
#
class dc_profile::puppet::puppet_master {

  include ::puppet::server
  include ::puppetdb::master::config
  include ::foreman::puppetmaster

  include ::puppetdeploy
  include ::dc_icinga::hostgroup_puppetmaster

  # Ensure puppetserver has performed its 'usermod' before allowing the
  # deploy ssh config to be installed: it changes the home directory
  # implicitly
  Class['::puppet::server::install'] -> Class['::puppetdeploy::puppet_user']

  # Ensure puppetdb notifies puppetserver to restart on modification
  Class['::puppetdb::master::config'] ~> Class['::puppet::server::service']

  # Ensure foreman alterations restart the server
  Class['::foreman::puppetmaster'] ~> Class['::puppet::server::service']

}

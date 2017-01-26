# == Class: dc_profile::puppet::puppet_master
#
# Installs a passenger based puppet master and support
# infrastructure
#
class dc_profile::puppet::puppet_master {

  include ::puppet
  include ::puppet::server
  include ::puppetdb::master::config
  include ::foreman::puppetmaster

  include ::puppetdeploy
  include ::dc_icinga::hostgroup_puppetmaster

  # Ensure puppetdb notifies puppetserver to restart on modification
  Class['::puppetdb::master::config'] ~> Class['::puppet::server::service']

  # Ensure foreman alterations restart the server
  Class['::foreman::puppetmaster'] ~> Class['::puppet::server::service']

}

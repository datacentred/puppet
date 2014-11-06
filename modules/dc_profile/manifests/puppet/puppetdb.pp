# Class: dc_profile::puppet::puppetdb
#
# Provisions a puppetdb service node
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::puppet::puppetdb {

  contain puppetdb::server

  # Puppetdb with default settings OOM kills itself so hack
  # the defaults to increase memory to 2GB
  exec { 'sed -i "s/-Xmx[[:digit:]]\+m/-Xmx2048m/" /etc/default/puppetdb':
    unless  => 'grep Xmx2048m /etc/default/puppetdb',
    require => Package['puppetdb'],
    notify  => Service['puppetdb'],
  }

  include ::dc_nrpe::puppetdb
  include ::dc_icinga::hostgroup_puppetdb

}


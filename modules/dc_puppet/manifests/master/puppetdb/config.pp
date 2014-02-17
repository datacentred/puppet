# Class: dc_puppet::master::puppetdb::config
#
# PuppetDB configuration
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::master::puppetdb::config {

  include dc_puppet::params
  $dir = $dc_puppet::params::dir

  File {
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { "${dir}/puppetdb.conf":
    content => template('dc_puppet/master/puppetdb/puppetdb.conf.erb'),
  }

  file { "${dir}/routes.yaml":
    content => template('dc_puppet/master/puppetdb/routes.yaml.erb'),
  }

}

# Class: dc_puppet::master::puppetdb::install
#
# PuppetDB terminius installation
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::master::puppetdb::install {
  
  include dc_puppet::params

  package { 'puppetdb-terminus':
    ensure => $dc_puppet::params::puppetdb_version,
  }

}

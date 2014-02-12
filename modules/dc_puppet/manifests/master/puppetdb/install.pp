#
class dc_puppet::master::puppetdb::install {
  
  include dc_puppet::params

  package { 'puppetdb-terminus':
    ensure => $dc_puppet::params::version,
  }

}

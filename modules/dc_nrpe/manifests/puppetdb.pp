# == Class: dc_nrpe::puppetdb
#
class dc_nrpe::puppetdb {

  file { '/etc/nagios/nrpe.d/puppetdb.cfg':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/dc_nrpe/puppetdb.cfg',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }

}

# == Class: dc_nrpe::configure
#
class dc_nrpe::configure {

  file { '/etc/nagios/nrpe.cfg':
    ensure  => file,
    path    => '/etc/nagios/nrpe.cfg',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/dc_nrpe/nrpe.cfg',
  }

  file { '/etc/nagios/nrpe.d':
    ensure => directory,
    purge  => true,
  }

  concat { '/etc/nagios/nrpe.d/dc_nrpe_check.cfg':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}

# == Class: dc_nrpe::install
#
class dc_nrpe::install {

  $nrpe_agent = $::operatingsystem ? {
    /(RedHat|CentOS)/ => 'nrpe',
    'Debian'          => 'nagios-nrpe-server',
  }

  package { $nrpe_agent:
    ensure => installed,
    alias  => 'nrpe-agent',
  }

  package { 'python-netifaces':
    ensure => installed,
  }

}

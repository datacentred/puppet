# Class to control the Nagios NSCA server
# Depends on nagios user being declared, so make
# it a requirement that dc_icinga::server is installed
# first
class dc_nsca::server {

  package { 'nsca':
    ensure => installed,
  }

  file { '/etc/nsca.cfg':
    ensure  => file,
    content => template('dc_nsca/nsca.cfg.erb'),
    require => Package['nsca'],
  }

  service { 'nsca':
    ensure    => running,
    subscribe => File['/etc/nsca.cfg'],
  }

}

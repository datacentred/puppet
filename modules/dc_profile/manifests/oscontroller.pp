class dc_profile::oscontroller {

  package { 'python-mysqldb':
    ensure => installed,
  }

}

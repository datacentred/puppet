class profile::hiera {

  package { 'hiera':
    provider => gem,
    ensure => installed,
  }

}

class profile::hiera {

  package { 'hiera':
    ensure   => installed,
    provider => gem,
  }

}

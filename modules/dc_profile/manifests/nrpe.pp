class dc_profile::nrpe {

  class { 'dc_nrpe':
    allowed_hosts    => '127.0.0.1 10.10.192.0/24',
  }

}

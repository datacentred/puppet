class dc_profile::monitoring::nrpe {

  $icinga_ip = hiera(icinga_ip)

  class { 'dc_nrpe':
    allowed_hosts    => "127.0.0.1 ${icinga_ip}/32",
  }

}

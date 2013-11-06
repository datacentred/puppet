class dc_profile::foreman_proxy {

  $omapi_key    = hiera(omapi_key)
  $omapi_secret = hiera(omapi_secret)

  class { 'dc_foreman_proxy' :
    use_dns      => true,
    use_dhcp     => true,
    omapi_key    => "$omapi_key",
    omapi_secret => "$omapi_secret"
  }

}

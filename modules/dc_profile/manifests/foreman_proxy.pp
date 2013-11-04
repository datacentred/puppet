class dc_profile::foreman_proxy {

  class { 'dc_foreman_proxy' :
    use_dns => true,
  }

}

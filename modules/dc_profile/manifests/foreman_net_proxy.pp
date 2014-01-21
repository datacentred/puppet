class dc_profile::foreman_net_proxy {

  $omapi_key    = hiera(omapi_key)
  $omapi_secret = hiera(omapi_secret)
  $tftproot     = hiera(tftproot)

  class { 'dc_foreman_proxy' :
    use_dns      => true,
    use_dhcp     => true,
    use_tftp     => true,
    omapi_key    => "$omapi_key",
    omapi_secret => "$omapi_secret",
    tftproot     => "$tftproot"
  }

  include dc_icinga::hostgroups
  realize Dc_external_facts::Fact::Def['dc_hostgroup_foreman_proxy']

}

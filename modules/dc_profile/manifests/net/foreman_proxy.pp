# Class: dc_profile::net::foreman_proxy
#
# Foreman proxy for network services: DNS, DHCP & TFTP
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::net::foreman_proxy {

  $omapi_key    = hiera(omapi_key)
  $omapi_secret = hiera(omapi_secret)
  $tftproot     = hiera(tftpdir)

  class { 'dc_foreman_proxy' :
    use_dns      => true,
    use_dhcp     => true,
    use_tftp     => true,
    omapi_key    => $omapi_key,
    omapi_secret => $omapi_secret,
    tftproot     => $tftproot,
  }

  include dc_icinga::hostgroups
  realize External_facts::Fact['dc_hostgroup_foreman_proxy']

}

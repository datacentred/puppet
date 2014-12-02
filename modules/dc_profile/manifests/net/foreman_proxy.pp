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

  class { 'dc_foreman_proxy' :
    use_dns      => true,
    use_dhcp     => true,
    use_tftp     => true,
    omapi_key    => $omapi_key,
    omapi_secret => $omapi_secret,
  }

  include dc_icinga::hostgroup_foreman_proxy

}

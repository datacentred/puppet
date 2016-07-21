# == Class: dc_profile::net::dns_master
#
# DNS master node
#
class dc_profile::net::dns_master {

  include ::dc_dns
  include ::dc_dns::static
  include ::dc_icinga::hostgroup_dns

  include ::dhcp
  include ::dhcp::ddns
  include ::dc_dhcp::primary
  include ::dc_apparmor::dhcpd
  include ::dc_icinga::hostgroup_dhcp

  include ::dc_tftp
  include ::dc_tftp::sync_master

  include ::foreman_proxy
  include ::foreman_proxy::plugin::discovery
  include ::dc_foreman::service_checks
  include ::dc_icinga::hostgroup_foreman_proxy

  include ::dc_icinga::hostgroup_ntp

  # The proxy requires the users to bin installed by the
  # requisite classes
  Class['dc_dns'] -> Class['foreman_proxy']
  Class['tftp'] -> Class['foreman_proxy::config']
  Class['dc_dhcp::primary::config'] -> Service[$dhcp::servicename]

}

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

  include ::dc_foreman_proxy
  include ::dc_foreman::service_checks
  include ::dc_icinga::hostgroup_foreman_proxy

  # The proxy requires the users to bin installed by the
  # requisite classes
  Class['dc_dns'] -> Class['dc_foreman_proxy']
  Class['dc_tftp'] -> Class['dc_foreman_proxy']

}

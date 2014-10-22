# Class: dc_role::dnsmaster
#
# Master DNS/DHCP/TFTP server and foreman endpoint
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::dnsmaster inherits dc_role {

  contain dc_profile::net::dnsbackup
  contain dc_profile::net::dns_master
  contain dc_profile::net::dhcpd_master
  contain dc_profile::net::tftpserver
  contain dc_profile::net::foreman_proxy

}

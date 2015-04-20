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
  contain dc_apparmor::dhcpd
  contain dc_profile::net::tftp_syncmaster
  contain dc_profile::net::foreman_proxy
  contain dc_icinga::hostgroup_dhcp
  contain dc_icinga::hostgroup_ntp
  contain dc_profile::net::duplicity_dns
  contain dc_backup::gpg_keys

}

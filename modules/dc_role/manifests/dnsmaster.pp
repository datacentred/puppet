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
class dc_role::dnsmaster {

  contain dc_profile::net::dnsbackup
  contain dc_profile::net::dns_master
  contain dc_icinga::hostgroup_ntp
  contain dc_profile::net::foreman_checks

}

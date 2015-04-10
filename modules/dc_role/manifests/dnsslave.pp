# Class: dc_role::dnsslave
#
# Slave DNS/DHCP/TFTP server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::dnsslave inherits dc_role {

  contain dc_profile::net::dnsbackup
  contain dc_profile::net::dns_slave
  contain dc_profile::net::dhcpd_slave
  contain dc_profile::net::tftp_syncslave
  contain dc_backup::duplicity_dnsbackups
  contain dc_icinga::hostgroup_ntp

}

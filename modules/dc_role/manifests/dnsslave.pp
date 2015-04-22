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

  contain dc_profile::net::dns_slave
  contain dc_profile::net::dhcpd_slave
  contain dc_profile::net::tftp_syncslave
  contain dc_profile::net::foreman_proxy
  contain dc_icinga::hostgroup_ntp
  contain dc_backup::gpg_keys
  contain dc_profile::net::duplicity_dns

}

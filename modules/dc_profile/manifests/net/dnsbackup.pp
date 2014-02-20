# Class: dc_profile::net::dnsbackup
#
# Performs periodic backups of DNS
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::net::dnsbackup {

  class { 'dc_dnsbackup':
    dnsbackupmount => '/var/zonebackups',
  }
  contain 'dc_dnsbackup'

}

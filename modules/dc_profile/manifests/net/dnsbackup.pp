#
class dc_profile::net::dnsbackup {

  class { 'dc_dnsbackup':
    dnsbackupmount => '/var/zonebackups',
  }
  contain 'dc_dnsbackup'

}

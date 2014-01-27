class dc_profile::dnsbackup {

  class { 'dc_dnsbackup':
    dnsbackupmount    => '/var/zonebackups',
  }

}

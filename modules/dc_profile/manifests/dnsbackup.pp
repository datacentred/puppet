class dc_profile::dnsbackup {

  anchor { 'dc_profile::dnsbackup::first': } ->
  class { 'dc_dnsbackup':
    dnsbackupmount    => '/var/zonebackups',
  } ->
  anchor { 'dc_profile::dnsbackup::last': }

}

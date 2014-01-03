class dc_profile::ntpgeneric {

  if $ipaddress in hiera(localtimeservers) {
    class { 'ntp':
      servers    => hiera(timeservers),
      autoupdate => false,
      restrict   => false,
    }
  }
  else {
    class { 'ntp':
      servers    => hiera(localtimeservers),
      autoupdate => false,
    }
  }
}

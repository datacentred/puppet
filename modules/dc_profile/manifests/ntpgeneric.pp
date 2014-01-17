class dc_profile::ntpgeneric {
  # if server address is in local then add remote servers
  if $ipaddress in hiera(localtimeservers) {
    class { 'ntp':
      servers    => hiera(timeservers),
      autoupdate => false,
    }
  }
  else {
    class { 'ntp':
      servers    => hiera(localtimeservers),
      autoupdate => false,
      restrict   => ['127.0.0.1'],
    }
  }
}

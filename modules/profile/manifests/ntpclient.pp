class profile::ntpclient {

  $localtimeservers = hiera('localtimeservers')

  class { 'ntp':
    servers    => $localtimeservers,
    autoupdate => false,
  }

}

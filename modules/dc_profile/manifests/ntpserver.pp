class dc_profile::ntpserver {

  $upstreamtimeservers = hiera_array('timeservers')

  class { 'ntp':
    servers    => $upstreamtimeservers,
    autoupdate => false,
    restrict   => false,
  }

  $defined = true

}

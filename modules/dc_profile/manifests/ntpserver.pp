class dc_profile::ntpserver {

  $upstreamtimeservers = hiera_array('timeservers')

  class { 'ntp':
    servers    => $upstreamtimeservers,
    autoupdate => false,
    restrict   => false,
  }

  include dc_icinga::hostgroups
  realize Dc_external_facts::Fact['dc_hostgroup_ntp']

}

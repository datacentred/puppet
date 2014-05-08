# Class: dc_profile::net::ntpgeneric
#
# Generic class for both NTP servers and clients
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::net::ntpgeneric {

  # if server address is in local then add remote servers
  if $::ipaddress in hiera(localtimeservers) {

    class { 'ntp':
      servers    => hiera(timeservers),
      autoupdate => false,
    }

    include dc_icinga::hostgroups
    realize Dc_external_facts::Fact['dc_hostgroup_ntp']

    @@dns_resource { "ntp.${::domain}/A":
      rdata => $::ipaddress,
    } 

  } else {

    class { 'ntp':
      servers    => hiera(localtimeservers),
      autoupdate => false,
      restrict   => ['127.0.0.1'],
    }

  }

}

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

  # Look up our timeservers
  $localtimeservers = hiera('localtimeservers')

  # Is the current server going to act as a local timeserver?
  if has_key($localtimeservers, $::fqdn) {

    # Setup NTP, using remote peers - allow query from everywhere
    class { 'ntp':
      servers    => $localtimeservers[$::fqdn]['servers'],
      autoupdate => false,
    }

    # Setup monitoring
    include dc_icinga::hostgroup_ntp

    # Add CNAME entry
    @@dns_resource { "${localtimeservers[$::fqdn]['cname']}/CNAME":
      rdata => $::fqdn,
    }

  } else {

    # Setup NTP, using local timeservers - don't allow queries
    class { 'ntp':
      servers    => hiera(timeservers),
      autoupdate => false,
      restrict   => ['127.0.0.1'],
    }

  }

}

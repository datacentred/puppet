# Class: dc_profile::puppet::puppet
#
# Manages puppet agents on all nodes and provisions the master
# see dc_puppet for more details
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::puppet::puppet {

  contain dc_puppet

  # TODO: Remove this virtual resource declaration once we
  # roll out a second Puppetmaster
  @@dns_resource { "puppet.${::domain}/CNAME":
    rdata => $::fqdn,
  }

}

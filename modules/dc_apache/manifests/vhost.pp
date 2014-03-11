# Class: dc_apache::vhost
#
# Creates a DataCentred vhost
#
# Parameters:
#
# $title specifies the hostname
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
define dc_apache::vhost (
  $docroot,
) {

  # Note: apache will refuse to fire up a vhost without
  # looking up the fqdn first.  So ensure a local entry
  # is present first before notifying the server
  host { "${title}.${::domain}":
    ip => $::ipaddress,
  } ->

  apache::vhost { "${title}.${::domain}":
    docroot           => $docroot,
    serveradmin       => hiera(sysmailaddress),
  }

  # Export the CNAME to the rest of the network
  if $title != $::hostname {
    @@dns_resource { "${title}.${::domain}/CNAME":
      rdata => $::fqdn,
    }
  }

}

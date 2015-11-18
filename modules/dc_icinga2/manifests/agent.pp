# == Class: dc_icinga2::agent
#
# Profile for an icinga2 agent
#
# === Parameters
#
# [*parent_fqdn*]
#   FQDN of the parent node.  Must be the same as the subject name of the X509
#   certificate used by the API
#
class dc_icinga2::agent (
  $parent_fqdn,
) {

  include ::icinga2
  include ::icinga2::features::api
  include ::icinga2::features::checker
  include ::icinga2::features::notification
  include ::icinga2::features::mainlog

  include ::dc_icinga2::host

  # Define the endpoint and zone of the parent satellite or master
  icinga2::object::endpoint { $parent_fqdn:
    host => $parent_fqdn,
  }

  icinga2::object::zone { $parent_fqdn:
    endpoints => [
      $parent_fqdn,
    ],
  }

  # Define the global-templates zone to acquire global configuration
  icinga2::object::zone { 'global-templates':
    global => true,
  }

  # Export the local endpoint and zone.  The master will collect unconditionally
  # satellites will collect conditionally based on the domain, and this node will
  # collect its own
  @@icinga2::object::endpoint { $::fqdn:
    tag => [ $::fqdn, $::domain ]
  }

  @@icinga2::object::zone { $::fqdn:
    endpoints => [
      $::fqdn,
    ],
    parent    => $parent_fqdn,
    tag       => [ $::fqdn, $::domain ]
  }

  # Collect all zone resources for the fqdn
  Icinga2::Object::Endpoint <<| tag == $::fqdn |>>

  Icinga2::Object::Zone <<| tag == $::fqdn |>>

}

# == Class: dc_icinga2::satellite
#
# Profile for an icinga2 satellite
#
# === Parameters
#
# [*parent_fqdn*]
#   FQDN of the parent node.  Must be the same as the subject name of the X509
#   certificate used by the API
#
# [*parent_host*]
#   IP address or hostname of the parent node.  If using a host name it must
#   be resolvable via DNS
#
class dc_icinga2::satellite (
  $parent_fqdn,
  $parent_host,
) {

  include ::icinga2
  include ::icinga2::features::api
  include ::icinga2::features::checker
  include ::icinga2::features::notification
  include ::icinga2::features::mainlog

  include ::dc_icinga2::host
  include ::dc_icinga2::pagerduty
  include ::dc_icinga2::sudoers

  # Define the endpoint and zone of the parent
  icinga2::object::endpoint { $parent_fqdn:
    host => $parent_host,
  }

  icinga2::object::zone { $parent_fqdn:
    endpoints => [
      $parent_fqdn,
    ],
  }

  icinga2::object::zone { 'global-templates':
    global => true,
  }

  # Export the local endpoint and zone
  @@icinga2::object::endpoint { $::fqdn:
    tag => $::fqdn,
  }

  @@icinga2::object::zone { $::fqdn:
    endpoints => [
      $::fqdn,
    ],
    parent    => $parent_fqdn,
    tag       => $::fqdn,
  }

  Icinga2::Object::Endpoint <<| tag == $::fqdn or tag == $::domain |>>

  Icinga2::Object::Zone <<| tag == $::fqdn or tag == $::domain |>>

}

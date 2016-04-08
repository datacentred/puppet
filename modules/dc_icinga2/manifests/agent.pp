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
# [*parent_host*]
#   IP address or hostname of the parent node.  If using a host name it must
#   be resolvable via DNS
#
# [*parent_domain*]
#   If an agent exists outside of the DNS zone of the northbound checker, set
#   this to that of the parent satellite/master
#
class dc_icinga2::agent (
  $parent_fqdn,
  $parent_host = undef,
  $parent_domain = undef,
) {

  include ::icinga2
  include ::icinga2::features::api
  include ::icinga2::features::checker
  include ::icinga2::features::notification
  include ::icinga2::features::mainlog

  include ::dc_icinga2::host
  include ::dc_icinga2::pagerduty::agent
  include ::dc_icinga2::sudoers

  if $parent_host {
    $_parent_host = $parent_host
  } else {
    $_parent_host = $parent_fqdn
  }

  # Define the endpoint and zone of the parent satellite or master
  icinga2::object::endpoint { $parent_fqdn:
    host => $_parent_host,
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
    tag => [ $::fqdn, $::domain, $parent_domain ]
  }

  @@icinga2::object::zone { $::fqdn:
    endpoints => [
      $::fqdn,
    ],
    parent    => $parent_fqdn,
    tag       => [ $::fqdn, $::domain, $parent_domain ]
  }

  # Collect all zone resources for the fqdn
  Icinga2::Object::Endpoint <<| tag == $::fqdn |>>

  Icinga2::Object::Zone <<| tag == $::fqdn |>>

}

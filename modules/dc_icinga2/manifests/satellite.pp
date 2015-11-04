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
# [*parent_domain*]
#   Parent domain to tag our resources with so that zone connectivity checks
#   are performed
#
class dc_icinga2::satellite (
  $parent_fqdn,
  $parent_host,
  $parent_domain,
  $icon_image = $::dc_icinga2::params::icon_image,
) inherits dc_icinga2::params {

  include ::icinga2
  include ::icinga2::features::api

  # Tag with the master domain so cluster-zone checks are performed
  tag $::fqdn, $parent_domain

  # Define the endpoint and zone of the parent
  icinga2::object::endpoint { $parent_fqdn:
    host => $parent_host,
  }

  icinga2::object::zone { $parent_fqdn:
    endpoints => [
      $parent_fqdn,
    ],
  }

  # Export the local endpoint and zone
  @@icinga2::object::endpoint { $::fqdn: }

  @@icinga2::object::zone { $::fqdn:
    endpoints => [
      $::fqdn,
    ],
    parent    => $parent_fqdn,
  }

  # Export the local host
  @@icinga2::object::host { $::fqdn:
    import       => 'generic-host',
    display_name => $::fqdn,
    address      => $::ipaddress,
    vars         => {
      'architecture'     => $::architecture,
      'lsbdistcodename'  => $::lsbdistcodename,
      'operatingsystem'  => $::operatingsystem,
      'os'               => $::kernel,
      'enable_pagerduty' => true,
    },
    icon_image   => $icon_image,
  }

  # Collect the local endpoint into zones.conf
  Icinga2::Object::Endpoint <<| tag == $::fqdn |>>

  Icinga2::Object::Zone <<| tag == $::fqdn |>>

  Icinga2::Object::Host <<| tag == $::fqdn |>>

  Icinga2::Object::Service <<| tag == $::fqdn |>>

  # Collect agents tagged with the satellite domain into repository.d
  Icinga2::Object::Endpoint <<| tag == $::domain |>> {
    repository => true,
  }

  Icinga2::Object::Zone <<| tag == $::domain |>> {
    repository => true,
  }

  Icinga2::Object::Host <<| tag == $::domain |>> {
    check_command => 'cluster-zone',
    repository    => true,
  }

  Icinga2::Object::Service <<| tag == $::domain |>> {
    import        => 'satellite-service',
    check_command => 'dummy',
    repository    => true,
  }

}

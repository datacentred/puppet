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
  $icon_image = $::dc_icinga2::params::icon_image,
) inherits dc_icinga2::params {

  include ::icinga2
  include ::icinga2::features::api

  # Tag all resources with the fqdn and domain.  The fqdn is used to collect
  # resources locally, the domain to collect on the satellite
  tag $::fqdn, $::domain

  # Define the endpoint and zone of the parent satellite or master
  icinga2::object::endpoint { $parent_fqdn:
    host => $parent_fqdn,
  }

  icinga2::object::zone { $parent_fqdn:
    endpoints => [
      $parent_fqdn,
    ],
  }

  # Define local resources and tag with the domain.  The satellite for
  # this domain and the master need to know about them
  @@icinga2::object::endpoint { $::fqdn: }

  @@icinga2::object::zone { $::fqdn:
    endpoints => [
      $::fqdn,
    ],
    parent    => $parent_fqdn,
  }

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
    zone         => $parent_fqdn,
    icon_image   => $icon_image,
  }

  # Collect all resources for the fqdn
  Icinga2::Object::Endpoint <<| tag == $::fqdn |>>

  Icinga2::Object::Zone <<| tag == $::fqdn |>>

  Icinga2::Object::Host <<| tag == $::fqdn |>>

  Icinga2::Object::Service <<| tag == $::fqdn |>>

}

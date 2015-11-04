# == Class: dc_icinga2::master
#
# Profile for an icinga2 master
#
class dc_icinga2::master (
  $icon_image = $::dc_icinga2::params::icon_image,
) inherits dc_icinga2::params {

  include ::icinga2
  include ::icinga2::web
  include ::icinga2::features::api
  include ::icinga2::features::command
  include ::icinga2::features::ido_mysql

  # Define our endpoint zone and host statically
  icinga2::object::endpoint { $::fqdn: }

  icinga2::object::zone { $::fqdn:
    endpoints => [
      $::fqdn
    ],
  }

  icinga2::object::host { $::fqdn:
    import       => 'generic-host',
    display_name => $::fqdn,
    address      => $::ipaddress,
    vars         => {
      'architecture'    => $::architecture,
      'lsbdistcodename' => $::lsbdistcodename,
      'operatingsystem' => $::operatingsystem,
      'os'              => $::kernel,
    },
    icon_image   => $icon_image,
  }

  # Collect our local checks
  Icinga2::Object::Service <<| tag == $::fqdn |>>

  # Collect endpoints and zones globally
  Icinga2::Object::Endpoint <<||>> {
    repository => true,
  }

  Icinga2::Object::Zone <<||>> {
    repository => true,
  }

  # Collect hosts in the local domain and perform cluster checks,
  # this also includes directly connected satellite hosts
  Icinga2::Object::Host <<| tag == $::domain |>> {
    check_command => 'cluster-zone',
    repository    => true,
  }

  # Collect hosts in remote domains performing no checks this is
  # performed via the satellites
  Icinga2::Object::Host <<| tag != $::domain |>> {
    check_command => 'dummy',
    repository    => true,
  }

  Icinga2::Object::Service <<| tag != $::fqdn |>> {
    import        => 'satellite-service',
    check_command => 'dummy',
    repository    => true,
  }

}

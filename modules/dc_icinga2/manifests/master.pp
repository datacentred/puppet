# == Class: dc_icinga2::master
#
# Profile for an icinga2 master
#
class dc_icinga2::master {

  # TODO: Move me when this gets refactored properly
  ca_certificate { 'puppet-ca':
    source => '/var/lib/puppet/ssl/certs/ca.pem',
  }

  include ::icinga2
  include ::icinga2::web
  include ::icinga2::features::api
  include ::icinga2::features::checker
  include ::icinga2::features::notification
  include ::icinga2::features::mainlog
  include ::icinga2::features::command
  include ::icinga2::features::ido_mysql
  include ::icinga2::features::graphitewriter

  include ::dc_icinga2::host
  include ::dc_icinga2::services
  include ::dc_icinga2::checks
  include ::dc_icinga2::groups
  include ::dc_icinga2::pagerduty
  include ::dc_icinga2::templates
  include ::dc_icinga2::timeperiods
  include ::dc_icinga2::users
  include ::dc_icinga2::sudoers

  icinga2::object::endpoint { $::fqdn: }

  icinga2::object::zone { $::fqdn:
    endpoints => [
      $::fqdn
    ],
  }

  icinga2::object::zone { 'global-templates':
    global => true,
  }

  Icinga2::Object::Endpoint <<||>>

  Icinga2::Object::Zone <<||>>

  Icinga2::Object::Host <<| |>>

}

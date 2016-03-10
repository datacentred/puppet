# == Class: dc_icinga2::users
#
# Define users
#
class dc_icinga2::users {

  icinga2::object::usergroup { 'icingaadmins':
    display_name => 'Icinga 2 Admin Group',
    target       => '/etc/icinga2/zones.d/global-templates/users.conf',
  }

  icinga2::object::user { 'icingaadmin':
    display_name => 'Icinga 2 Admin',
    groups       => [
      'icingaadmins',
    ],
    target       => '/etc/icinga2/zones.d/global-templates/users.conf',
  }

  icinga2::object::apiuser { 'dashing':
    client_cn   => 'simon.murray@datacentred.co.uk',
    permissions => [ '*' ],
  }
}

# == Class: dc_icinga2::users
#
# Define users
#
class dc_icinga2::users {

  icinga2::object::usergroup { 'icingaadmins':
    display_name => 'Icinga 2 Admin Group',
  }

  icinga2::object::user { 'icingaadmin':
    display_name => 'Icinga 2 Admin',
    groups       => [
      'icingaadmins',
    ],
  }

}

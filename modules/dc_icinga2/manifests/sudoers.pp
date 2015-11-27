# == Class: dc_icinga2::sudoers
#
# Allows the nagios/icinga user to execute scripts in the local
# plugins directory with elevated privileges
#
class dc_icinga2::sudoers {

  sudo::conf { $::dc_icinga2::user:
    content => "${::dc_icinga2::user} ALL=(root) NOPASSWD: /usr/local/lib/nagios/plugins/*",
  }

}

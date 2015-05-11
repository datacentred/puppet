# == Class: dc_ssh
#
# Generic SSH daemon configuration.  Locks out root login and
# limits access to specific user groups
#
# === Parameters
#
# [*allowed_groups*]
#   POSIX groups allowed to ssh into a machine
#
# === Notes
#
# Typically the groups are sourced from common.yaml for most machines,
# platform specific overrides are provided where necessary so grep for
# all affected configurations when adding new groups (e.g. the vagrant
# group on vagrant platforms allows vagrant ssh to function)
#
class dc_ssh (
  $allowed_groups,
) {

  validate_array($allowed_groups)

  service { 'ssh':
    ensure     => true,
    enable     => true,
    hasrestart => true
  }

  sshd_config { 'AllowGroups':
    ensure => present,
    value  => $allowed_groups,
    notify => Service['ssh']
  }

  sshd_config { 'PermitRootLogin':
    ensure => present,
    value  => 'no',
    notify => Service['ssh']
  }

}

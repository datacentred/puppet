# == Class: dc_ssh
#
class dc_ssh (
  $allowed_groups,
) {

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

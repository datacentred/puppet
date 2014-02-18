# Class: dc_profile::net::ssh
#
# This uses the custom types from the augueasproviders module
# so that needs to be installed on the puppetmaster for this to work.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::ssh {

  service { 'ssh':
    ensure     => true,
    enable     => true,
    hasrestart => true
  }

  sshd_config { 'AllowGroups':
    ensure => present,
    value  => ['sysadmin', 'git', 'postgres', 'barman'],
    notify => Service['ssh']
  }

  sshd_config { 'PermitRootLogin':
    ensure => present,
    value  => 'no',
    notify => Service['ssh']
  }

}

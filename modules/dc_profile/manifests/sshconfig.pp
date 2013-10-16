# This uses the custom types from the augueasproviders module
# so that needs to be installed on the puppetmaster for this to work.

class dc_profile::sshconfig {

  service { 'ssh':
    ensure     => true,
    enable     => true,
    hasrestart => true
  }

  sshd_config { 'AllowGroups':
    ensure => present,
    value  => 'sysadmin',
    notify => Service['ssh']
  }

  sshd_config { 'PermitRootLogin':
    ensure => present,
    value  => 'no',
    notify => Service['ssh']
  }

}

# Class: dc_profile::openstack::nova_ssh
#
# OpenStack Nova compute profile class
#
# Parameters:
#
# Actions:
#
# Requires: nova
#
# Sample Usage:
#
class dc_profile::openstack::nova_ssh {

  file { '/var/lib/nova/.ssh':
    ensure  => directory,
    owner   => 'nova',
    group   => 'nova',
    mode    => '0700',
    require => Class['::Nova'],
  }

  file { '/var/lib/nova/.ssh/config':
    ensure  => file,
    source  => 'puppet:///modules/dc_openstack/ssh_config',
    owner   => 'nova',
    group   => 'nova',
    mode    => '0600',
    require => File['/var/lib/nova/.ssh'],
  }

}

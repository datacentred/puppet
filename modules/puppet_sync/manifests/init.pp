# == Class: puppet_sync
#
# Synchronises /etc/puppet/environments across masters
#
# === Parameters
#
# [*targets*]
#   Array of hosts to synchronise to
#
class puppet_sync (
  $targets  = [],
  $excludes = [],
) {

  include ::lsyncd

  if versioncmp($::puppetversion, '4.0.0') >= 0 {
    $_ssldir = '/etc/puppetlabs/puppet/ssl'
  } else {
    $_ssldir = '/var/lib/puppet/ssl'
  }

  lsyncd::process { 'puppetcrl':
    content => template('puppet_sync/puppetcrl.lua.erb'),
    owner   => 'puppet',
    group   => 'puppet',
  }

  lsyncd::process { 'puppet':
    content => template('puppet_sync/puppet.lua.erb'),
    owner   => 'puppet',
    group   => 'puppet',
  }

}

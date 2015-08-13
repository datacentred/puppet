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
  $targets = [],
) {

  include ::lsyncd

  lsyncd::process { 'puppet':
    content => template('puppet_sync/puppet.lua.erb'),
    owner   => 'puppet',
    group   => 'puppet',
  }

}

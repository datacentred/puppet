# Class: dc_rails::files
#
# Setup files and directories for a Rails server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_rails::files(
  $home = undef,
  $log_base = undef,
  $run_base = undef,
  $user = undef,
  $group = undef,
) {
  file { "${home}.ssh" :
    ensure => 'directory',
    owner  => $user,
    group  => $group,
    mode   => '0700',
  } ->

  file { "${home}.ssh/id_rsa" :
    ensure => present,
    owner  => $user,
    group  => $group,
    mode   => '0600',
    source => 'puppet:///modules/dc_rails/deployer_keys/id_rsa',
  } ->

  file { "${home}.ssh/id_rsa.pub" :
    ensure => present,
    owner  => $user,
    group  => $group,
    mode   => '0600',
    source => 'puppet:///modules/dc_rails/deployer_keys/id_rsa.pub',
  } ->

  file { "${home}.ssh/known_hosts" :
    ensure => present,
    owner  => $user,
    group  => $group,
    mode   => '0600',
    source => 'puppet:///modules/dc_rails/deployer_keys/known_hosts',
  }

  file { [$log_base, $run_base]:
    ensure => directory,
    owner  => $user,
    group  => $group,
  }

}
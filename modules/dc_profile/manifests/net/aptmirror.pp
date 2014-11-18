# Class: dc_profile::net::aptmirror
#
# Creates an apt mirror
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::net::aptmirror {

  $storagedir = hiera(storagedir)

  if $::hostgroup =~ /HA\ Raid/ {
    $base_path = "${storagedir}/apt-mirror"
  } else {
    $base_path = '/var/spool/apt-mirror'
  }

  include apache

  dc_apache::vhost { 'mirror':
    docroot     => "${base_path}/mirror",
    require     => [ File[$base_path], Class['apt_mirror']],
  }

  file { $base_path:
    ensure => directory,
  }

  # Use enabled = false so that we can redirect the stdout in a custom cron job
  class { 'apt_mirror':
    enabled   => false,
    base_path => $base_path,
    var_path  => '/var/spool/apt-mirror/var',
    require   => File[$base_path],
  }

  cron { "apt-mirror-${hostname}":
    ensure  => 'present',
    user    => 'root',
    command => '/usr/bin/apt-mirror /etc/apt/mirror.list >/dev/null',
    minute  => 0,
    hour    => 4,
  }

  $mirror_defaults = {
    os => '',
  }
  create_resources(apt_mirror::mirror, hiera(mirror_list), $mirror_defaults)

}

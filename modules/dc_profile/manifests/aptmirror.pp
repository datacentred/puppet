class dc_profile::aptmirror {

  $storagedir = hiera(storagedir)

  if $::hostgroup =~ /HA\ Raid/ {
    $base_path = "${storagedir}/apt-mirror"
  }
  else {
    $base_path = '/var/spool/apt-mirror'
  }

  include apache

  apache::vhost { 'mirror':
    docroot     => "${base_path}/mirror",
    require     => [ File["${base_path}"], Class['apt_mirror']],
    serveradmin => hiera(sysmailaddress)
  }

  file { "${base_path}":
    ensure => directory,
  }

  class { 'apt_mirror':
    base_path => "${base_path}",
    var_path  => '/var/spool/apt-mirror/var',
    require   => File["${base_path}"],
  }

  $mirror_defaults = {
    os => '',
  }
  create_resources(apt_mirror::mirror, hiera(mirror_list), $mirror_defaults)

}


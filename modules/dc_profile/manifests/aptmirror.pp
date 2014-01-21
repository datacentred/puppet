class dc_profile::aptmirror {

  $storagedir = hiera(storagedir)

  if $hostgroup == 'Production/Platform Services/HA Raid' {
    $base_path = "${storagedir}/apt-mirror"
  }
  else {
    $base_path = '/var/spool/apt-mirror'
  }

  include dc_mirrors::mirrorlist
  include apache

  apache::site { 'mirror':
    docroot => "${base_path}/mirror",
    require => [ File["${base_path}"], Class['apt_mirror']],
    admin   => hiera(sysmailaddress)
  }

  file { "$base_path":
    ensure => directory,
  }

  class { 'apt_mirror':
    base_path => "${base_path}",
    var_path  => '/var/spool/apt-mirror/var',
    require   => File["${base_path}"],
  }

  Dc_mirrors::Virtual::Mirror <| |>

}


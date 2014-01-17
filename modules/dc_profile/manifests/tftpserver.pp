class dc_profile::tftpserver {

  $storagedir = hiera(storagedir)

  if $hostgroup == 'Production/Platform Services/HA Raid' {
    $tftpdir = "$storagedir/tftp"
  }
  else {
    $tftpdir = hiera('tftpdir')
  }

  file { "$tftpdir":
    ensure => directory
  }

  class { 'tftp':
    require   => File["$tftpdir"],
    directory => "$tftpdir",
    inetd     => false,
  }

}

class dc_profile::tftpserver {

  if $hostgroup == 'Production/Platform Services/HA Raid' {
    $tftpdir = '/var/storage/tftp'
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

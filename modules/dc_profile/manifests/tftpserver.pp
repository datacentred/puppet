class dc_profile::tftpserver {

  $tftpdir = hiera('tftpdir')

  file { "$tftpdir":
    ensure => directory
  }

  class { 'tftp':
    require   => File["$tftpdir"],
    directory => "$tftpdir",
    inetd     => false,
  }

}

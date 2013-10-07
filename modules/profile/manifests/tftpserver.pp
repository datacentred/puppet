class profile::tftpserver {

  $tftpdir = hiera('tftpdir')

  class { 'tftp':
    directory => "$tftpdir",
    inetd     => false,
  }

}

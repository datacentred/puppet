# == Class: dc_kibana::install
#
class dc_kibana::install {

  file { '/var/www':
        ensure  => directory,
        recurse => true,
  }


}

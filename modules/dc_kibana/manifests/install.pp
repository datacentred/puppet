class dc_kibana::install {
  file { '/var/www/kibana':
        ensure  => directory,
        source  => 'puppet:///modules/dc_kibana/',
        purge   => true,
        recurse => true,
  }
}

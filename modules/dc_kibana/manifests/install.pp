class dc_kibana::install {
  file {
      "/var/www/kibana/":
        source => "puppet:///modules/dc_kibana/",
        ensure => directory,
        replace => true,
        purge   => true,
        recurse => true;
  }
}

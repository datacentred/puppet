# == Class: dc_apt_mirror::configure
#
# Configure the apt-mirror service
#
class dc_apt_mirror::configure {

  include ::apache

  $mirror_defaults = {
    os => '',
  }

  file { $dc_apt_mirror::base_path:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0775',
  } ->

  # Disable the automatic service.  The cron job is a bit chatty
  # on stdout so we redirect this to /dev/null
  class { '::apt_mirror':
    enabled   => false,
    base_path => $dc_apt_mirror::base_path,
    var_path  => $dc_apt_mirror::var_path,
  } ->

  apache::vhost { "mirror.${::domain}":
    port          => 80,
    docroot       => "${dc_apt_mirror::base_path}/mirror",
    serveraliases => [ 'mirror' ],
  }

  create_resources('apt_mirror::mirror', $dc_apt_mirror::mirrors, $mirror_defaults)

}

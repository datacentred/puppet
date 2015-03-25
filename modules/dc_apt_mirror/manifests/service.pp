# == Class: dc_apt_mirror::service
#
# Controls the apt-mirror service
#
class dc_apt_mirror::service {

  cron { "apt-mirror-${::hostname}":
    ensure  => present,
    user    => 'root',
    command => '/usr/bin/apt-mirror /etc/apt/mirror.list >/dev/null',
    minute  => 0,
    hour    => 4,
  }

}

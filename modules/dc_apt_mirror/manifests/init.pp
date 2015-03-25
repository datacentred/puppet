# == Class: dc_apt_mirror
#
# DataCentred apt-mirror configuration.  Installs apt-mirror
# schedules mirror updates and exposes the mirrored repos
# via HTTP
#
# === Parameters
#
# [*base_path*]
#   The base directory for apt repositories
#
class dc_apt_mirror (
  $base_path = '/var/spool/apt-mirror',
  $var_path = '$base_path/var',
  $mirrors = {},
) {

  contain ::dc_apt_mirror::configure
  contain ::dc_apt_mirror::service

  Class['::dc_apt_mirror::configure'] ->
  Class['::dc_apt_mirror::service']

}

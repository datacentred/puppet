# == Class: dc_tftp::configure
#
# Configures the TFTP service
#
class dc_tftp::configure {

  assert_private()

  include ::tftp

  File {
    ensure => directory,
    owner  => $dc_tftp::tftp_user,
    group  => $dc_tftp::tftp_group,
    mode   => $dc_tftp::dir_mode,
  }

  user { $dc_tftp::tftp_user:
    ensure => present,
    system => true,
  } ->

  file { $dc_tftp::tftp_dir: } ->

  file { "${dc_tftp::tftp_dir}/boot": } ->

  file { "${dc_tftp::tftp_dir}/pxelinux.cfg": } ->

  # TODO: Consider puppetizing https://datacentred.atlassian.net/wiki/display/DEV/TFTP when on Xenial

  Class['::tftp']

}

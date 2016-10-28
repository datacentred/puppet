# == Class: dc_tftp
#
# Installs TFTP, basic configuration and HA synchronisation
#
class dc_tftp (
  $sync_slave,
  $ssh_private_key,
  $ssh_public_key,
  $tftp_dir = '/var/tftpboot',
  $use_inetd = false,
  $tftp_sync_user = 'tftpsync',
  $tftp_sync_group = 'tftpsync',
  $tftp_sync_home = '/var/lib/tftpsync',
  $tftp_user = 'tftp',
  $tftp_group = 'tftp',
  $dir_mode = '2775',
  $conf_template = 'dc_tftp/lsyncd.conf.lua.trusty.erb',
  $master = true,
  $address = $::ipaddress,
) {

  include ::dc_tftp::install
  include ::dc_tftp::configure
  include ::dc_tftp::sync_user
  include ::dc_tftp::sync_master

  Class['::dc_tftp::install'] ->
  Class['::dc_tftp::configure'] ->
  Class['::dc_tftp::sync_user'] ->
  Class['::dc_tftp::sync_master']

}

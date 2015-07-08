# Class: dc_tftp
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_tftp (
  $tftp_dir        = $dc_tftp::params::tftp_dir,
  $address         = $dc_tftp::params::address,
  $ha_sync         = $dc_tftp::params::ha_sync,
  $sync_master     = $dc_tftp::params::sync_master,
  $sync_slave      = $dc_tftp::params::sync_slave,
  $sync_interface  = $dc_tftp::params::sync_interface,
  $use_inetd       = $dc_tftp::params::use_inetd,
  $tftp_sync_user  = $dc_tftp::params::tftp_sync_user,
  $tftp_sync_group = $dc_tftp::params::tftp_sync_group,
  $tftp_sync_home  = $dc_tftp::params::tftp_sync_home,
  $tftp_user       = $dc_tftp::params::tftp_user,
  $tftp_group      = $dc_tftp::params::tftp_group,
  $dir_mode        = $dc_tftp::params::dir_mode,
  $conf_template   = $dc_tftp::params::conf_template,
) inherits dc_tftp::params {

  contain dc_tftp::install

}

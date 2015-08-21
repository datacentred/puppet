# == Class: dc_nrpe::checks::bmc
#
class dc_nrpe::checks::bmc (
  $std_fw_version = '1',
  $bmc_admin_name = 'admin',
  $bmc_admin_password = 'password',
  $ipmi_monitor_user = 'nagios',
  $ipmi_monitor_password = 'password',
) {

  dc_nrpe::check { 'check_bmc':
    path    => '/usr/local/bin/check_bmc',
    content => template('dc_nrpe/check_bmc.erb'),
    sudo    => true,
  }

}

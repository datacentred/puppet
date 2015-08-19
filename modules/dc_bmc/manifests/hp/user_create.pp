# == Class: dc_bmc::hp::user_create
#
# Creates and iLO user
#
class dc_bmc::hp::user_create {

  include ::dc_bmc

  $ipmi_user_channel = $dc_bmc::ipmi_user_channel
  $ipmi_monitor_user = $dc_bmc::ipmi_monitor_user
  $ipmi_monitor_password = $dc_bmc::ipmi_monitor_password

  file { '/etc/createilouser.xml':
    ensure  => file,
    content => template('dc_bmc/hp/createilouser.xml.erb'),
  } ~>

  exec { 'hponcfg_user_create':
    command     => '/usr/sbin/hponcfg -f /etc/createilouser.xml',
    refreshonly => true,
    unless      => "ipmitool user list ${ipmi_user_channel} | awk \'{print \$2}\' | grep ${ipmi_monitor_user} >/dev/null",
  }

}

# == Class: dc_bmc::hp::user_modify
#
# Modifies and iLO user
#
class dc_bmc::hp::user_modify {

  include ::dc_bmc

  $ipmi_monitor_user = $dc_bmc::ipmi_monitor_user
  $ipmi_monitor_password = $dc_bmc::ipmi_monitor_password

  file { '/etc/modifyilouser.xml':
    ensure  => file,
    content => template('dc_bmc/hp/modifyilouser.xml.erb'),
  } ~>

  exec { 'hponcfg_user_mod':
    command     => '/usr/sbin/hponcfg -f /etc/modifyilouser.xml',
    refreshonly => true,
  }

}

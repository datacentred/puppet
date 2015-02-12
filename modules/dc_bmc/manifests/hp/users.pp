# Class: dc_bmc::hp::users
#
# Class to provision users via the ILO
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_bmc::hp::users {

  file { '/etc/createilouser.xml':
    ensure  => file,
    content => template('dc_bmc/hp/createilouser.xml.erb'),
    notify  => Exec['hponcfg_user_create'],
  }

  exec { 'hponcfg_user_create':
    command     => '/usr/sbin/hponcfg -f /etc/createilouser.xml',
    refreshonly => true,
    unless      => "ipmitool user list ${dc_bmc::ipmi_user_channel} | awk \'{print \$2}\' | grep ${dc_bmc::ipmi_monitor_user} >/dev/null",
  }

  file { '/etc/modifyilouser.xml':
    ensure  => file,
    content => template('dc_bmc/hp/modifyilouser.xml.erb'),
    notify  => Exec['hponcfg_user_mod'],
    require => [ File['/etc/createilouser.xml'], Exec['hponcfg_user_create'] ],
  }

  exec { 'hponcfg_user_mod':
    command     => '/usr/sbin/hponcfg -f /etc/modifyilouser.xml',
    refreshonly => true,
  }

}

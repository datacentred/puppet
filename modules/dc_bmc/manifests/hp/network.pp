# == Class: dc_bmc::hp::network
#
# Configure iLO networking
#
class dc_bmc::hp::network {

  file { $dc_bmc::ilo_net_settings_file:
    ensure  => present,
    content => template('dc_bmc/hp/ilonetconfig.xml.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644'
  } ~>

  exec { 'install hponcfg':
    command     => "hponcfg -f ${dc_bmc::ilo_net_settings_file} -l ${dc_bmc::ilo_net_settings_log}",
    refreshonly => true,
  }

}

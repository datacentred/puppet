# Class: dc_bmc::hp::network
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_bmc::hp::network {

    exec { 'first install hponcfg':
      command => "/usr/sbin/hponcfg -f ${dc_bmc::ilo_net_settings_file} -l ${dc_bmc::ilo_net_settings_log}",
      require => [ File[$dc_bmc::ilo_net_settings_file], Package['hponcfg']],
      creates => $dc_bmc::ilo_net_settings_log,
      path    => '/bin:/usr/sbin:/usr/bin',
      timeout => 0,
    }

    exec { 'refresh only hponcfg':
      command     => "/usr/sbin/hponcfg -f ${dc_bmc::ilo_net_settings_file} -l ${dc_bmc::ilo_net_settings_log}",
      require     => [ File[$dc_bmc::ilo_net_settings_file], Package['hponcfg']],
      refreshonly => true,
      subscribe   => File [$dc_bmc::ilo_net_settings_file],
      path        => '/bin:/usr/sbin:/usr/bin',
      timeout     => 0,
    }

    package { 'hponcfg':
      ensure => 'present',
    }

    file { $dc_bmc::ilo_net_settings_file:
      ensure  => present,
      content => template('dc_bmc/hp/ilonetconfig.xml.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644'
    }

}

# Class: dc_bmc::supermicro::http_scripted
#
# Scripted update of the BMC config unavailable via IPMI
#
#
class dc_bmc::supermicro::http_scripted {

  $_bmc_admin_name = $::dc_bmc::bmc_admin_name
  $_bmc_admin_passwd = $::dc_bmc::bmc_admin_passwd
  $_radius_server_ip = $::dc_bmc::radius_server
  $_radius_secret = $::dc_bmc::radius_secret

  ensure_packages('curl')

  Package['curl'] ->

  file { '/usr/local/bin/sm_http.rb':
    ensure => file,
    source => 'puppet:///modules/dc_bmc/supermicro/sm_http.rb',
    owner  => 'root',
    group  => 'root',
    mode   => '0775',
  } ->

  file { '/usr/local/bin/sm_http_wrapper.sh':
    content => template('dc_bmc/supermicro/sm_http_wrapper.sh.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
  } ~>

  exec { 'sm_http_wrapper':
    command     => '/usr/local/bin/sm_http_wrapper.sh',
    refreshonly => true,
  }

}

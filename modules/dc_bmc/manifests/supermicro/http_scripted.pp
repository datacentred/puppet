# Class: dc_bmc::supermicro::http_scripted
#
# Scripted update of the BMC config unavailable via IPMI
#
#
class dc_bmc::supermicro::http_scripted {

  $radius_server_ip = get_ip_addr($dc_bmc::radius_server)

  ensure_packages(['curl'])

  file { '/usr/local/bin/sm_http.rb':
    ensure => file,
    source => 'puppet:///modules/dc_bmc/supermicro/sm_http.rb',
    owner  => 'root',
    group  => 'root',
    mode   => '0775',
  }

  file { '/usr/local/bin/sm_http_wrapper.sh':
    content => template('dc_bmc/supermicro/sm_http_wrapper.sh.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    require => File['/usr/local/bin/sm_http.rb'],
  }

  exec { 'sm_http_wrapper':
    command     => '/usr/local/bin/sm_http_wrapper.sh',
    subscribe   => File['/usr/local/bin/sm_http_wrapper.sh'],
    refreshonly => true,
    require     => Class['dc_bmc::admin'],
  }

}

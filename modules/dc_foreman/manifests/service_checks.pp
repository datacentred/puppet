# Class dc_foreman::service_checks
class dc_foreman::service_checks (
  $foreman_url,
  $foreman_admin_pw,
  $foreman_admin_user,
  $omapi_key,
  $omapi_secret,
  $omapi_port,
  $tftp_dir,
  $dhcp_server,
  $lease_file,
){

  ensure_packages(['python-pip', 'git'])

  package { 'pypureomapi':
    ensure   => 'd56018c1e022977720f87de8675f372f629f6ca6',
    provider => 'pip',
    source   => 'git+https://github.com/CygnusNetworks/pypureomapi.git',
    require  => Package['python-pip'],
  }

  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { '/usr/local/bin/foreman_check.py':
    ensure => file,
    source => 'puppet:///modules/dc_foreman/foreman_check.py',
    mode   => '0755',
  }

  file { '/usr/local/lib/python2.7/dist-packages/dc_foreman.py':
    ensure => file,
    source => 'puppet:///modules/dc_foreman/dc_foreman.py'
  }

  file { '/usr/local/lib/python2.7/dist-packages/dc_omapi.py':
    ensure => file,
    source => 'puppet:///modules/dc_foreman/dc_omapi.py'
  }

  file { '/usr/local/etc/foreman_check.config':
    ensure  => file,
    content => template('dc_foreman/foreman_check_config.erb'),
  }

  cron { 'foreman_check':
    command => '/usr/local/bin/foreman_check.py',
    hour    => 2,
    minute  => 0,
  }

}

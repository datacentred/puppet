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

  package { 'pypureomapi':
    ensure   => installed,
    provider => 'pip',
  }

  file { '/usr/local/bin/foreman_check.py':
    ensure => file,
    source => 'puppet:///modules/dc_foreman/foreman_check.py',
  }

  file { '/usr/local/lib/python2.7/site-packages/dc_foreman.py':
    ensure => absent,
    source => 'puppet:///modules/dc_foreman/dc_foreman.py'
  }

  file { '/usr/local/lib/python2.7/site-packages/dc_omapi.py':
    ensure => absent,
    source => 'puppet:///modules/dc_foreman/dc_omapi.py'
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

}

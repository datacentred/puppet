# Class dc_foreman::service_checks
class dc_foreman::service_checks (
  $foreman_url,
  $foreman_view_api_pw,
  $foreman_view_api_user,
  $omapi_key,
  $omapi_secret,
  $omapi_port,
  $tftp_dir,
  $dhcp_server,
  $lease_file,
  $dns_key,
  $proxy_alias = $::fqdn,
){

  include ::dc_foreman::python_lib

  $_key = "/etc/puppetlabs/puppet/ssl/private_keys/${::fqdn}.pem"
  $_cert = "/etc/puppetlabs/puppet/ssl/certs/${::fqdn}.pem"
  $_cacert = '/etc/puppetlabs/puppet/ssl/certs/ca.pem'

  ensure_packages(['python-pip', 'git'])

  package { 'pypureomapi':
    provider => 'pip',
    source   => 'git+https://github.com/CygnusNetworks/pypureomapi.git',
    require  => Package['python-pip'],
  }

  package { 'dnspython':
    provider => 'pip',
    require  => Package['python-pip'],
  }

  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { '/usr/local/lib/python2.7/dist-packages/dc_omapi.py':
    ensure => file,
    source => 'puppet:///modules/dc_foreman/dc_omapi.py'
  }

  file { '/usr/local/bin/foreman_check.py':
    ensure => file,
    source => 'puppet:///modules/dc_foreman/foreman_check.py',
    mode   => '0755',
  }

  file { '/usr/local/bin/load_from_foreman.py':
    ensure => file,
    source => 'puppet:///modules/dc_foreman/load_from_foreman.py',
    mode   => '0755',
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

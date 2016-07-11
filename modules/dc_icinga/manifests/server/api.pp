# Class:
#
# Installs Nagios API
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_icinga::server::api {

  $packages = [
    'python-dev',
    'libssl-dev',
    'libffi-dev',
    'python-pip',
  ]

  ensure_packages($packages)

  $pip_packages = [
    'nagios-api',
    'pyopenssl',
    'diesel',
    'greenlet',
  ]

  ensure_packages($pip_packages, { 'provider' => 'pip'})

  Package['python-pip'] -> Package[$pip_packages]
  ->
  file { '/etc/init/nagios_api.conf':
    ensure  => file,
    owner   => 'nagios',
    group   => 'nagios',
    mode    => '0770',
    content => template('dc_icinga/nagios_api.conf.erb')
  } ->
  file { '/var/log/nagios_api/':
    ensure => directory,
    owner  => 'nagios',
    group  => 'nagios',
    mode   => '0770'
  } ->
  file { '/var/log/nagios_api/output.log':
    ensure => file,
    owner  => 'nagios',
    group  => 'nagios',
    mode   => '0770'
  } ->
  file { '/var/run/nagios_api/':
    ensure => directory,
    owner  => 'nagios',
    group  => 'nagios',
    mode   => '0770'
  } ->
  service { 'nagios_api':
    ensure => running,
  }
}

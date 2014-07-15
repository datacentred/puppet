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

  package { 'python-dev':
    ensure => present,
  } ->
  package { 'libssl-dev':
    ensure => present,
  } ->
  package { 'libffi-dev':
    ensure => present,
  } ->
  package { 'python-pip':
    ensure => present,
  } ->
  package { 'nagios-api':
    ensure   => present,
    provider => 'pip',
  } ->
  package { 'pyopenssl':
    ensure   => present,
    provider => 'pip',
  } ->
  package { 'diesel':
    ensure   => present,
    provider => 'pip',
  } ->
  package { 'greenlet':
    ensure   => present,
    provider => 'pip',
  } ->
  file { '/etc/init/nagios_api.conf':
    ensure  => file,
    owner   => 'nagios',
    group   => 'nagios',
    mode    => '0770',
    content => template('dc_icinga/nagios_api.conf.erb')
  } ->
  file { '/var/log/nagios_api/':
    ensure  => directory,
    owner   => 'nagios',
    group   => 'nagios',
    mode    => '0770'
  } ->
  file { '/var/log/nagios_api/output.log':
    ensure  => file,
    owner   => 'nagios',
    group   => 'nagios',
    mode    => '0770'
  } ->
  file { '/var/run/nagios_api/':
    ensure  => directory,
    owner   => 'nagios',
    group   => 'nagios',
    mode    => '0770'
  } ->
  service { 'nagios_api':
    ensure => running,
  }
}

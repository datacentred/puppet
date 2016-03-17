#
# == Class dc_profile::perf::telegraf
#
class dc_profile::perf::telegraf {

  include ::telegraf

  # TODO: Remove once this stuff has been nuked
  service { ['stunnel-graphite', 'stunnel-influxdb']:
    ensure => stopped,
  } ->
  package { 'stunnel4':
    ensure => purged,
  }

  user { 'telegraf':
    ensure  => present,
    groups  => 'puppet',
    require => Package['telegraf'],
  }

}

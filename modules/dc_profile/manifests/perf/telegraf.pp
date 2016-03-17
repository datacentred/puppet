#
# == Class dc_profile::perf::telegraf
#
class dc_profile::perf::telegraf {

  include ::telegraf

  user { 'telegraf':
    ensure  => present,
    groups  => 'puppet',
    require => Package['telegraf'],
  }

}

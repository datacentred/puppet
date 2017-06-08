#
# == Class dc_profile::perf::telegraf
#
class dc_profile::perf::telegraf {

  include ::telegraf

  $grouplist = lookup('telegraf_groups', Array[String], 'unique')

  user { 'telegraf':
    ensure  => present,
    groups  => $grouplist,
    require => Package['telegraf'],
  }

}

# Class: dc_rally::schedule
#
# Schedules a load test and a verification test
#
class dc_rally::schedule (
  $username     = $dc_rally::params::username,
  $rallyhome    = $dc_rally::params::rallyhome
) inherits dc_rally::params {

  # Nova load tests
  file { "${rallyhome}/boot-and-delete.json":
    ensure  => file,
    content => template('dc_rally/boot-and-delete.json.erb'),
    require => Vcsrepo["${rallyhome}/rally"],
  }

  cron { 'loadtest_nova':
    user    => $username,
    command => "/usr/local/bin/rally task start ${rallyhome}/boot-and-delete.json",
    minute  => 0,
    hour    => 0,
    require => File["${rallyhome}/boot-and-delete.json"],
  }

  # Nova
  cron { 'verify_compute':
    user    => $username,
    command => '/usr/local/bin/rally verify start --set compute',
    minute  => 0,
    hour    => 1,
  }

  # Glance
  cron { 'verify_image':
    user    => $username,
    command => '/usr/local/bin/rally verify start --set image',
    minute  => 0,
    hour    => 2,
  }

  # Neutron
  cron { 'verify_network':
    user    => $username,
    command => '/usr/local/bin/rally verify start --set network',
    minute  => 0,
    hour    => 3,
  }

  # Keystone
  cron { 'verify_identity':
    user    => $username,
    command => '/usr/local/bin/rally verify start --set identity',
    minute  => 0,
    hour    => 4,
  }

}

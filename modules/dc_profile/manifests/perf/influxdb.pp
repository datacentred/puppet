# Class dc_profile::perf::influxdb
#
# Installs and configures InfluxDB
#
class dc_profile::perf::influxdb {
  include ::influxdb::server

  ensure_packages(['curl', 'srvadmin-storageservices'])

  $data_dir = '/srv/influxdb'

  file { [ $data_dir, "${data_dir}/data", "${data_dir}/wal" ]:
    ensure  => directory,
    owner   => 'influxdb',
    group   => 'influxdb',
    require => Package['influxdb'],
  }

  logrotate::rule { 'influxdb':
    path         => '/var/log/influxdb/influxd.log',
    rotate       => 7,
    rotate_every => 'day',
    ifempty      => false,
    compress     => true,
    copytruncate => true,
    dateext      => true,
    missingok    => true,
  }

}

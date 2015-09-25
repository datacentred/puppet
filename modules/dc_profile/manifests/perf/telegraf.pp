#
# == Class dc_profile::perf::telegraf
#
class dc_profile::perf::telegraf {

  include ::stunnel
  include ::telegraf

  $influxdb_server  = hiera(influxdb_server)
  $influxdb_port    = hiera(influxdb_port)

  stunnel::tun { 'influxdb':
    accept      => '18086',
    connect     => "${influxdb_server}:${influxdb_port}",
    cert        => "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
    cafile      => '/var/lib/puppet/ssl/certs/ca.pem',
    global_opts => {
      'key' => "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem" },
    client      => true,
  }

  # FIXME
  #
  package { [ 'collectd', 'telegraf' ]:
    ensure => purged,
  }

}

# == Class dc_profile::perf::collectd_stunnel
#
# Configure SSL-encrypted tunnel for performance data
#
class dc_profile::perf::collectd_stunnel {

  include ::stunnel

  $graphite = hiera(graphite_server)

  stunnel::tun { 'graphite':
    accept      => '20030',
    connect     => "${graphite}:2003",
    cert        => "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
    cafile      => '/var/lib/puppet/ssl/certs/ca.pem',
    global_opts => { key => "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem" },
    client      => true,
  }

}

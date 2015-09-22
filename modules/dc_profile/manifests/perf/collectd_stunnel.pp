# == Class dc_profile::perf::collectd_stunnel
#
# Configure SSL-encrypted tunnel for performance data
#
class dc_profile::perf::collectd_stunnel {

  include ::stunnel

  stunnel::cert { 'graphite':
    components => [ "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
                    "/var/lib/puppet/ssl/certs/${::fqdn}.pem" ],
  }

  stunnel::tun { 'graphite':
    accept  => '20030',
    connect => hiera(graphite_server),
    client  => true,
  }

}

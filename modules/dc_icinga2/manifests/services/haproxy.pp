# == Class: dc_icinga2::services::haproxy
#
# Checks for broken haproxy services or members that are down
#
class dc_icinga2::services::haproxy {

  icinga2::object::apply_service { 'core services':
    import        => 'generic-service',
    check_command => 'haproxy',
    vars          => {
      'haproxy_host'       => 'stats.datacentred.services',
      'haproxy_privatekey' => '/var/lib/puppet/ssl/private_keys/$host.name$.pem',
      'haproxy_clientcert' => '/var/lib/puppet/ssl/certs/$host.name$.pem',
      'haproxy_perfdata'   => 'scur',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "monitoring_master"',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}

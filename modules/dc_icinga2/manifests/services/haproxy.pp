# == Class: dc_icinga2::services::haproxy
#
# Checks for broken haproxy services or members that are down
#
class dc_icinga2::services::haproxy {

  Icinga2::Object::Apply_service {
    target => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

  icinga2::object::apply_service { 'haproxy port 443':
    import        => 'generic-service',
    check_command => 'haproxy',
    display_name  => 'haproxy',
    vars          => {
      'haproxy_host'       => 'stats.datacentred.services',
      'haproxy_privatekey' => '/var/lib/puppet/ssl/private_keys/$host.name$.pem',
      'haproxy_clientcert' => '/var/lib/puppet/ssl/certs/$host.name$.pem',
      'haproxy_perfdata'   => 'scur',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "monitoring_master"',
  }

  icinga2::object::apply_service { 'haproxy port 1936':
    import        => 'generic-service',
    check_command => 'haproxy',
    display_name  => 'haproxy',
    vars          => {
      'haproxy_host'       => 'host.name',
      'haproxy_port'       => 1936,
      'haproxy_privatekey' => '/var/lib/puppet/ssl/private_keys/$host.name$.pem',
      'haproxy_clientcert' => '/var/lib/puppet/ssl/certs/$host.name$.pem',
      'haproxy_perfdata'   => 'scur',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role in ["ceph_radosgatewaylb", "openstack_proxies"]',
  }

}

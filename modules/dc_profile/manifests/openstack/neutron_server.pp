# Class: dc_profile::openstack::neutron_server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::neutron_server {

  $os_region = hiera(os_region)

  # OpenStack API and loadbalancer endpoint
  $osapi_public  = 'compute.datacentred.io'

  $keystone_neutron_password = hiera(keystone_neutron_password)

  $rabbitmq_hosts    = hiera(osdbmq_members)
  $rabbitmq_username = hiera(osdbmq_rabbitmq_user)
  $rabbitmq_password = hiera(osdbmq_rabbitmq_pw)
  $rabbitmq_port     = hiera(osdbmq_rabbitmq_port)
  $rabbitmq_vhost    = hiera(osdbmq_rabbitmq_vhost)

  $neutron_secret = hiera(neutron_secret)

  $neutron_db      = hiera(neutron_db)
  $neutron_db_host = $osapi_public
  $neutron_db_user = hiera(neutron_db_user)
  $neutron_db_pass = hiera(neutron_db_pass)

  $management_ip      = $::ipaddress
  $integration_ip     = $::ipaddress_p1p1

  # enable the neutron service
  class { '::neutron':
      enabled               => true,
      bind_host             => '0.0.0.0',
      rabbit_hosts          => $rabbitmq_hosts,
      rabbit_user           => $rabbitmq_username,
      rabbit_password       => $rabbitmq_password,
      rabbit_port           => $rabbitmq_port,
      rabbit_virtual_host   => $rabbitmq_vhost,
      allow_overlapping_ips => true,
      core_plugin           => 'ml2',
      service_plugins       => [ 'router', 'firewall', 'lbaas', 'vpnaas' ],
  }

  # configure authentication
  class { 'neutron::server':
      auth_host              => $osapi_public,
      auth_protocol          => 'https',
      auth_password          => $keystone_neutron_password,
      database_connection    => "mysql://${neutron_db_user}:${neutron_db_pass}@${neutron_db_host}/${neutron_db}?charset=utf8",
  }

  include dc_profile::auth::sudoers_neutron

  # Nagios stuff
  include dc_icinga::hostgroup_neutron_server
  include dc_nrpe::neutron

  # Enable ML2 plugin
  class { 'neutron::plugins::ml2':
      type_drivers         => [ 'gre' ],
      tenant_network_types => [ 'gre' ],
      mechanism_drivers    => [ 'openvswitch' ],
      tunnel_id_ranges     => [ '1:1000' ],
  }

  # Add this node's API services into our loadbalancer
  @@haproxy::balancermember { "${::fqdn}-neutron":
    listening_service => 'icehouse-neutron',
    server_names      => $::hostname,
    ipaddresses       => $management_ip,
    ports             => '9696',
    options           => 'check inter 2000 rise 2 fall 5',
  }

}

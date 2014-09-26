# Class: dc_profile::openstack::nova_compute
#
# OpenStack Nova compute profile class
#
# Parameters:
#
# Actions:
#
# Requires: nova, neutron, vswitch
#
# Sample Usage:
#
class dc_profile::openstack::nova_compute {

  # OpenStack API and loadbalancer endpoint
  $osapi_public  = 'openstack.datacentred.io'

  $os_region         = hiera(os_region)
  $os_service_tenant = hiera(os_service_tenant)

  $rabbitmq_hosts    = hiera(osdbmq_members)
  $rabbitmq_username = hiera(osdbmq_rabbitmq_user)
  $rabbitmq_password = hiera(osdbmq_rabbitmq_pass)
  $rabbitmq_port     = hiera(osdbmq_rabbitmq_port)
  $rabbitmq_vhost    = hiera(osdbmq_rabbitmq_vhost)

  $nova_db_user = hiera(nova_db_user)
  $nova_db_pass = hiera(nova_db_pass)
  $nova_db_host = $osapi_public
  $nova_db      = hiera(nova_db)

  $novnc_proxy_host = 'openstack.datacentred.io'

  $keystone_neutron_password = hiera(keystone_neutron_password)

  $neutron_admin_user  = hiera(neutron_admin_user)
  $neutron_server_host = hiera(neutron_server_host)
  $neutron_secret      = hiera(neutron_secret)

  $management_ip = $::ipaddress

  $nova_database = "mysql://${nova_db_user}:${nova_db_pass}@${nova_db_host}/${nova_db}"

  include dc_profile::auth::sudoers_nova

  # Make sure the Nova instance / image cache has the right permissions set
  file { 'nova_instance_cache':
    path    => '/var/lib/nova/instances',
    owner   => 'nova',
    group   => 'nova',
    require => Class['::Nova'],
  }

  class { '::nova':
    database_connection => $nova_database,
    image_service       => 'nova.image.glance.GlanceImageService',
    glance_api_servers  => "https://${osapi_public}:9292",
    rabbit_hosts        => $rabbitmq_hosts,
    rabbit_userid       => $rabbitmq_username,
    rabbit_password     => $rabbitmq_password,
    rabbit_virtual_host => $rabbitmq_vhost,
    rabbit_port         => $rabbitmq_port,
  }

  class { '::nova::compute':
    enabled                       => true,
    vnc_enabled                   => true,
    vncproxy_host                 => $novnc_proxy_host,
    vncserver_proxyclient_address => $management_ip,
    vncproxy_protocol             => 'https',
  }

  class { 'nova::compute::libvirt':
    vncserver_listen  => '0.0.0.0',
    migration_support => true,
  }

  class { 'nova::compute::neutron':
    libvirt_vif_driver => 'nova.virt.libvirt.vif.LibvirtHybridOVSBridgeDriver',
  }

  # Configures nova.conf entries applicable to Neutron.
  class { 'nova::network::neutron':
    neutron_auth_strategy     => 'keystone',
    neutron_url               => "https://${osapi_public}:9696",
    neutron_admin_username    => $neutron_admin_user,
    neutron_admin_password    => $keystone_neutron_password,
    neutron_admin_tenant_name => $os_service_tenant,
    neutron_admin_auth_url    => "https://${osapi_public}:35357/v2.0",
    neutron_region_name       => $os_region,
  }

  if $::environment == 'production' {

    # Logstash config
    include dc_profile::openstack::nova_compute_logstash

    file { '/etc/nagios/nrpe.d/nova_compute.cfg':
      ensure  => present,
      content => 'command[check_nova_compute_proc]=/usr/lib/nagios/plugins/check_procs -c 1: -u nova -a nova-compute',
      require => Package['nagios-nrpe-server'],
      notify  => Service['nagios-nrpe-server'],
    }
  }

}

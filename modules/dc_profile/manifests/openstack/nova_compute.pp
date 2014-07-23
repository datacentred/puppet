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

  $os_region                  = hiera(os_region)
  $os_service_tenant          = hiera(os_service_tenant)

  $nova_mq_username           = hiera(nova_mq_username)
  $nova_mq_password           = hiera(nova_mq_password)
  $nova_mq_port               = hiera(nova_mq_port)
  $nova_mq_vhost              = hiera(nova_mq_vhost)

  $nova_db_user               = hiera(nova_db_user)
  $nova_db_pass               = hiera(nova_db_pass)
  $nova_db_host               = hiera(nova_db_host)
  $nova_db                    = hiera(nova_db)

  $novnc_proxy_host           = get_exported_var('', 'novnc_proxy_host', ['localhost'])

  $keystone_neutron_password  = hiera(keystone_neutron_password)

  $neutron_admin_user         = hiera(neutron_admin_user)
  $neutron_server_host        = hiera(neutron_server_host)
  $neutron_secret             = hiera(neutron_secret)

  $management_ip              = $::ipaddress_eth0

  # OpenStack API endpoint
  $osapi       = "osapi.${::domain}"

  # Hard coded exported variable name
  $nova_mq_ev                 = 'nova_mq_node'

  $nova_database              = "mysql://${nova_db_user}:${nova_db_pass}@${nova_db_host}/${nova_db}"

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
    glance_api_servers  => "https://${osapi}:9292",
    rabbit_hosts        => get_exported_var('', $nova_mq_ev, []),
    rabbit_userid       => $nova_mq_username,
    rabbit_password     => $nova_mq_password,
    rabbit_virtual_host => $nova_mq_vhost,
    rabbit_port         => $nova_mq_port,
    use_syslog          => true,
  }

  class { '::nova::compute':
    enabled                       => true,
    vnc_enabled                   => true,
    vncproxy_host                 => $novnc_proxy_host,
    vncserver_proxyclient_address => $management_ip,
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
    neutron_url               => "https://${osapi}:9696",
    neutron_admin_username    => $neutron_admin_user,
    neutron_admin_password    => $keystone_neutron_password,
    neutron_admin_tenant_name => $os_service_tenant,
    neutron_admin_auth_url    => "https://${osapi}:35357/v2.0",
    neutron_region_name       => $os_region,
  }

  if defined( Class['dc_profile::mon::icinga_client'] )
  {
    file { '/etc/nagios/nrpe.d/nova_compute.cfg':
      ensure  => present,
      content => 'command[check_nova_compute_proc]=/usr/lib/nagios/plugins/check_procs -c 1: -u nova -a nova-compute',
      require => Package['nagios-nrpe-server'],
      notify  => Service['nagios-nrpe-server'],
    }
  }


}

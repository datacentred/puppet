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

  $os_region              = hiera(os_region)
  $os_service_tenant      = hiera(os_service_tenant)

  $nova_mq_username       = hiera(nova_mq_username)
  $nova_mq_password       = hiera(nova_mq_password)
  $nova_mq_port           = hiera(nova_mq_port)
  $nova_mq_vhost          = hiera(nova_mq_vhost)

  $glance_api_servers     = get_exported_var('', 'glance_api_server', ['localhost:9292'])

  $keystone_host          = get_exported_var('', 'keystone_host', ['localhost'])
  $keystone_neutron_password = hiera(keystone_neutron_password)

  $neutron_admin_user     = hiera(neutron_admin_user)
  $neutron_server_host    = hiera(neutron_server_host)
  $neutron_secret         = hiera(neutron_secret)

  # Hard coded exported variable name
  $nova_mq_ev             = 'nova_mq_node'

  $nova_database          = "mysql://${nova_db_user}:${nova_db_pass}@${nova_db_host}/${nova_db}"

  class { 'nova':
    database_connection => $nova_database,
    glance_api_servers  => join($glance_api_servers, ','),
    rabbit_hosts        => get_exported_var('', $nova_mq_ev, []),
    rabbit_userid       => $nova_mq_username,
    rabbit_password     => $nova_mq_password,
    rabbit_port         => $nova_mq_port,
    rabbit_virtual_host => $nova_mq_vhost,
    use_syslog          => true,
    neutron_enabled     => true,
  }

  class { 'nova::compute':
    enabled         => true,
    vnc_enabled     => true,
    neutron_enabled => false,
  }

  class { 'nova::compute::libvirt':
    migration_support => true,
  }

  class { 'nova::compute::neutron':
    libvirt_vif_driver => $libvirt_vif_driver,
  }
  
  # Configures nova.conf entries applicable to Neutron.
  class { 'nova::network::neutron':
    neutron_auth_strategy     => 'keystone',
    neutron_url               => "http://${neutron_server_host}:9696",
    neutron_admin_username    => $neutron_admin_user,
    neutron_admin_password    => $keystone_neutron_password,
    neutron_admin_tenant_name => $os_service_tenant,
    neutron_admin_auth_url    => "http://${keystone_host}:35357/v2.0",
  }

  contain 'nova'

}

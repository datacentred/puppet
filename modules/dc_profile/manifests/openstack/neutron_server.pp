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

  $keystone_host      = get_exported_var('', 'keystone_host', ['localhost'])

  $nova_mq_username   = hiera(nova_mq_username)
  $nova_mq_password   = hiera(nova_mq_password)
  $nova_mq_port       = hiera(nova_mq_port)
  $nova_mq_vhost      = hiera(nova_mq_vhost)

  $neutron_secret     = hiera(neutron_secret)

  $neutron_db         = hiera(neutron_db)
  $neutron_db_host    = hiera(neutron_db_host)
  $neutron_db_user    = hiera(neutron_db_user)
  $neutron_db_pass    = hiera(neutron_db_pass)

  # enable the neutron service
  class { 'neutron':
      enabled             => true,
      bind_host           => '0.0.0.0',
      rabbit_hosts        => get_exported_var('', $nova_mq_ev, []),
      rabbit_user         => $nova_mq_username,
      rabbit_password     => $nova_mq_password,
      rabbit_port         => $nova_mq_port,
      rabbit_virtual_host => $nova_mq_vhost,
      verbose             => false,
      debug               => false,
  }
  
  # configure authentication
  class { 'neutron::server':
      auth_host       => $keystone_host,
      auth_password   => $neutron_secret,
      sql_connection  => "mysql://${neutron_db_user}:${neutron_db_pass}@${neutron_db_host}/${neutron_db}?charset=utf8",
  }
  
  # enable the Open VSwitch plugin server
  class { 'neutron::plugins::ovs':
      tenant_network_type => 'gre',
  } 

}

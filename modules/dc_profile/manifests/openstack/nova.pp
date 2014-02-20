# Class: dc_profile::openstack::nova
#
# Nova controller node
# As a starter for 10 ;-) it fits the bill, I do however think in time
# this could be split up into a more modular rather than monolithic
# blob dependent on what our use case turns out to be - SM
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::nova {

  $keystone_nova_password = hiera(keystone_nova_password)

  $os_region           = hiera(os_region)

  $nova_mq_username    = hiera(nova_mq_username)
  $nova_mq_password    = hiera(nova_mq_password)
  $nova_mq_port        = hiera(nova_mq_port)
  $nova_mq_vhost       = hiera(nova_mq_vhost)

  $glance_api_servers  = get_exported_var('', 'glance_api_server', ['localhost:9292'])

  $nova_db_root_pw     = hiera(nova_db_root_pw)
  $nova_db_user        = hiera(nova_db_user)
  $nova_db_pass        = hiera(nova_db_pass)
  $nova_db_host        = hiera(nova_db_host)
  $nova_db             = hiera(nova_db)

  $nova_admin_tenant   = hiera(nova_admin_tenant)
  $nova_admin_user     = hiera(nova_admin_user)
  $nova_admin_password = hiera(nova_admin_password)
  $nova_enabled_apis   = hiera(nova_enabled_apis)

  $keystone_host       = get_exported_var('', 'keystone_host', ['localhost'])

  $neutron_secret      = hiera(neutron_secret)

  $ec2_port = '8773'
  $nova_port = '8774'

  # Hard coded exported variable name
  $nova_mq_ev = 'nova_mq_node'

  $nova_database = "mysql://${nova_db_user}:${nova_db_pass}@${nova_db_host}/${nova_db}"

  # Check to see if we need to install the data base locally
  if $nova_db_host == '127.0.0.1' {

    class { 'dc_mariadb':
      maria_root_pw => $nova_db_root_pw,
    }
    contain 'dc_mariadb'

    dc_mariadb::db { $nova_db:
      user     => $nova_db_user,
      password => $nova_db_pass,
      require  => Class['Dc_mariadb'],
      before   => Class['::nova'],
    }

  }

  class { '::nova':
    database_connection => $nova_database,
    glance_api_servers  => join($glance_api_servers, ','),
    rabbit_hosts        => get_exported_var('', $nova_mq_ev, []),
    rabbit_userid       => $nova_mq_username,
    rabbit_password     => $nova_mq_password,
    rabbit_port         => $nova_mq_port,
    rabbit_virtual_host => $nova_mq_vhost,
    use_syslog          => true,
  }
  contain 'nova'

  class { '::nova::api':
    enabled                              => true,
    admin_tenant_name                    => $nova_admin_tenant,
    admin_user                           => $nova_admin_user,
    admin_password                       => $keystone_nova_password,
    enabled_apis                         => $nova_enabled_apis,
    auth_host                            => $keystone_host,
    auth_uri                             => "http://${keystone_host}:5000/v2.0",
    neutron_metadata_proxy_shared_secret => $neutron_secret,
  }
  contain 'nova::api'

  class { [
    'nova::cert',
    'nova::conductor',
    'nova::consoleauth',
    'nova::scheduler',
    'nova::vncproxy'
  ]:
    enabled => true,
  }

  @@keystone_endpoint { "${os_region}/nova":
    ensure        => present,
    public_url    => "http://${::fqdn}:${nova_port}/v2/%(tenant_id)s",
    admin_url     => "http://${::fqdn}:${nova_port}/v2/%(tenant_id)s",
    internal_url  => "http://${::fqdn}:${nova_port}/v2/%(tenant_id)s",
    tag           => 'nova_endpoint',
  }

  @@keystone_endpoint { "${os_region}/nova_ec2":
    ensure        => present,
    public_url    => "http://${::fqdn}:${ec2_port}/services/Cloud",
    admin_url     => "http://${::fqdn}:${ec2_port}/services/Admin",
    internal_url  => "http://${::fqdn}:${ec2_port}/services/Cloud",
    tag           => 'nova_endpoint',
  }

}

# Nova controller node
class dc_profile::nova {

  realize Dc_repos::Virtual::Repo['local_cloudarchive_mirror']

  $nova_mq_username    = hiera(nova_mq_username)
  $nova_mq_password    = hiera(nova_mq_password)
  $nova_mq_port        = hiera(nova_mq_port)
  $nova_mq_vhost       = hiera(nova_mq_vhost)

  $glance_api_servers  = hiera(glance_api_servers)

  $nova_db_user        = hiera(nova_db_user)
  $nova_db_pass        = hiera(nova_db_pass)
  $nova_db_host        = hiera(nova_db_host)
  $nova_db             = hiera(nova_db)

  $nova_admin_tenant   = hiera(nova_admin_tenant)
  $nova_admin_user     = hiera(nova_admin_user)
  $nova_admin_password = hiera(nova_admin_password)
  $nova_enabled_apis   = hiera(nova_enabled_apis)

  $keystone_host       = hiera(keystone_host)

  $neutron_secret      = hiera(neutron_secret)

  # Hard coded exported variable name
  $nova_mq_ev = 'nova_mq_node'

  $nova_database = "mysql://${nova_db_user}:${nova_db_pass}@${nova_db_host}/${nova_db}"

  class { '::nova':
    database_connection => $nova_database,
    glance_api_servers  => $glance_api_servers,
    rabbit_hosts        => get_exported_var('', $nova_mq_ev, []),
    rabbit_userid       => $nova_mq_username,
    rabbit_password     => $nova_mq_password,
    rabbit_port         => $nova_mq_port,
    rabbit_virtual_host => $nova_mq_vhost,
    use_syslog          => true,
    require             => Dc_repos::Virtual::Repo['local_cloudarchive_mirror'],
  }

  class { '::nova::api':
    enabled                              => true,
    admin_tenant_name                    => $nova_admin_tenant,
    admin_user                           => $nova_admin_user,
    admin_password                       => $nova_admin_password,
    enabled_apis                         => $nova_enabled_apis,
    auth_host                            => $keystone_host,
    neutron_metadata_proxy_shared_secret => $neutron_secret,
    require                              => Dc_repos::Virtual::Repo['local_cloudarchive_mirror'],
  }

}

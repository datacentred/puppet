# Glance API and registry server
class dc_profile::glance {

  $glance_api_db   = hiera(glance_api_db)
  $glance_api_user = hiera(glance_api_user)
  $glance_api_pass = hiera(glance_api_pass)
  $glance_api_host = hiera(glance_api_host)

  $glance_reg_db   = hiera(glance_reg_db)
  $glance_reg_user = hiera(glance_reg_user)
  $glance_reg_pass = hiera(glance_reg_pass)
  $glance_reg_host = hiera(glance_reg_host)

  class { 'glance::api':
    registry_host     => 'localhost',
    auth_type         => 'keystone',
    auth_host         => $keystone_host,
    keystone_tenant   => 'services',
    keystone_user     => 'glance',
    keystone_password => $keystone_glance_password,
    sql_connection    => "mysql://${glance_api_user}:${glance_api_pass}@${glance_api_host}/${glance_api_db}",
    use_syslog        => true,
    enabled           => true,
  }

  class { 'glance::registry':
    auth_type         => 'keystone',
    auth_host         => $keystone_host,
    keystone_tenant   => 'services',
    keystone_user     => 'glance',
    keystone_password => $keystone_glance_password,
    sql_connection    => "mysql://${glance_reg_user}:${glance_reg_pass}@${glance_reg_host}/${glance_reg_db}",
    use_syslog        => true,
    enabled           => true,
  }

}

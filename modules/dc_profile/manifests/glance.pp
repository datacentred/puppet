# Glance API and registry server
class dc_profile::glance {

  $glance_api_db   = hiera(glance_api_db)
  $glance_api_user = hiera(glance_api_user)
  $glance_api_pass = hiera(glance_api_pass)

  $glance_reg_db   = hiera(glance_reg_db)
  $glance_reg_user = hiera(glance_reg_user)
  $glance_reg_pass = hiera(glance_reg_pass)

  class { 'mysql::server': }

  mysql::db { $glance_api_db:
    user     => $glance_api_user,
    password => $glance_api_pass,
    require  => Class['mysql::server'],
  }

  mysql::db { $glance_reg_db:
    user     => $glance_reg_user,
    password => $glance_reg_pass,
    require  => Class['mysql::server'],
  }

  class { 'glance::api':
    registry_host     => 'localhost',
    auth_type         => 'keystone',
    auth_host         => $keystone_host,
    keystone_tenant   => 'services',
    keystone_user     => 'glance',
    keystone_password => $keystone_glance_password,
    sql_connection    => "mysql://${glance_api_user}:${glance_api_pass}@localhost/${glance_api_db}",
    use_syslog        => true,
    enabled           => true,
    require           => Mysql::Db[$glance_api_db],
  }
  contain 'glance::api'

  class { 'glance::registry':
    auth_type         => 'keystone',
    auth_host         => $keystone_host,
    keystone_tenant   => 'services',
    keystone_user     => 'glance',
    keystone_password => $keystone_glance_password,
    sql_connection    => "mysql://${glance_reg_user}:${glance_reg_pass}@localhost/${glance_reg_db}",
    use_syslog        => true,
    enabled           => true,
    require           => Mysql::Db[$glance_reg_db],
  }
  contain 'glance::registry'

}

# Glance API and registry server
class dc_profile::glance {

  $keystone_host = get_exported_var('', 'keystone_host', ['localhost'])
  $keystone_glance_password = hiera(keystone_glance_password)

  $glance_db_root_pw = hiera(glance_db_root_pw)

  $glance_api_db   = hiera(glance_api_db)
  $glance_api_user = hiera(glance_api_user)
  $glance_api_pass = hiera(glance_api_pass)

  $glance_reg_db   = hiera(glance_reg_db)
  $glance_reg_user = hiera(glance_reg_user)
  $glance_reg_pass = hiera(glance_reg_pass)

  class { 'dc_mariadb':
    maria_root_pw => $glance_db_root_pw,
  }
  contain 'dc_mariadb'

  dc_mariadb::db { $glance_api_db:
    user     => $glance_api_user,
    password => $glance_api_pass,
    require  => Class['Dc_mariadb'],
  }

  dc_mariadb::db { $glance_reg_db:
    user     => $glance_reg_user,
    password => $glance_reg_pass,
    require  => Class['Dc_mariadb'],
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
    require           => Dc_mariadb::Db[$glance_api_db],
  }
  contain 'glance::api'

  exported_vars::set { 'glance_api_server':
    value => "${::fqdn}:9292",
  }

  class { 'glance::registry':
    auth_type         => 'keystone',
    auth_host         => $keystone_host,
    keystone_tenant   => 'services',
    keystone_user     => 'glance',
    keystone_password => $keystone_glance_password,
    sql_connection    => "mysql://${glance_reg_user}:${glance_reg_pass}@localhost/${glance_reg_db}",
    use_syslog        => true,
    enabled           => true,
    require           => Dc_mariadb::Db[$glance_reg_db],
  }
  contain 'glance::registry'

  # TODO: Temporary backend while boot-strapping CEPH
  class { 'glance::backend::file':
  }
  contain 'glance::backend::file'

}

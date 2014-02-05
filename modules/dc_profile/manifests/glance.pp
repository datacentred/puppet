# Glance API and registry server
class dc_profile::glance {

  realize Dc_repos::Virtual::Repo['local_cloudarchive_mirror']

  $keystone_host = 'keystone.sal01.datacentred.co.uk'
  $keystone_glance_password = 'Deojun8OmEji'

  $glance_api_db   = hiera(glance_api_db)
  $glance_api_user = hiera(glance_api_user)
  $glance_api_pass = hiera(glance_api_pass)

  $glance_reg_db   = hiera(glance_reg_db)
  $glance_reg_user = hiera(glance_reg_user)
  $glance_reg_pass = hiera(glance_reg_pass)

  @@keystone_user { 'glance':
    ensure   => present,
    enabled  => true,
    password => $keystone_glance_password,
    tenant   => 'services',
  }

  # Okay so here is the sad part, because of all the includes and inherits in
  # the 3rd party code, these packages get installed well before the apt
  # repositories are updated and we get old versions, which causes the install
  # to fail!
  Dc_repos::Virtual::Repo['local_cloudarchive_mirror'] -> Package['mysql-client']
  Dc_repos::Virtual::Repo['local_cloudarchive_mirror'] -> Package['glance']
  Dc_repos::Virtual::Repo['local_cloudarchive_mirror'] -> Package['python-keystone']
  Dc_repos::Virtual::Repo['local_cloudarchive_mirror'] -> Package['mysql-server']

  contain mysql::server

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
    require           => [
      Mysql::Db[$glance_api_db],
      Dc_repos::Virtual::Repo['local_cloudarchive_mirror'],
    ],
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
    require           => [
      Mysql::Db[$glance_reg_db],
      Dc_repos::Virtual::Repo['local_cloudarchive_mirror'],
    ],
  }
  contain 'glance::registry'

}

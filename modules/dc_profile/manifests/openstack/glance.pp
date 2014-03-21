# Class: dc_profile::openstack::glance
#
# Openstack image API and registry server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::glance {

  $keystone_host = get_exported_var('', 'keystone_host', ['localhost'])
  $keystone_glance_password = hiera(keystone_glance_password)

  $os_region = hiera(os_region)

  $glance_api_db   = hiera(glance_api_db)
  $glance_api_user = hiera(glance_api_user)
  $glance_api_pass = hiera(glance_api_pass)
  $glance_api_host = hiera(glance_api_host)

  $glance_reg_db   = hiera(glance_reg_db)
  $glance_reg_user = hiera(glance_reg_user)
  $glance_reg_pass = hiera(glance_reg_pass)
  $glance_reg_host = hiera(glance_reg_host)

  $glance_port = "9292"

  $glance_api_database = "mysql://${glance_api_user}:${glance_api_pass}@${glance_api_host}/${glance_api_db}"
  $glance_reg_database = "mysql://${glance_reg_user}:${glance_reg_pass}@${glance_reg_host}/${glance_reg_db}"

  # Optionally install the database package
  if '127.0.0.1' in [$glance_api_host, $glance_reg_host] {

    contain dc_mariadb

    # Optionally install each database
    # TODO: I suspect this could be a shared class to be
    #       included in case you wished to provision on
    #       another host
    if $glance_api_host == '127.0.0.1' {
      dc_mariadb::db { $glance_api_db:
        user     => $glance_api_user,
        password => $glance_api_pass,
        require  => Class['Dc_mariadb'],
      }
    }
    if $glance_reg_host == '127.0.0.1' {
        dc_mariadb::db { $glance_reg_db:
        user     => $glance_reg_user,
        password => $glance_reg_pass,
        require  => Class['Dc_mariadb'],
      }
    }

  }

  class { 'glance::api':
    registry_host     => 'localhost',
    auth_type         => 'keystone',
    auth_host         => $keystone_host,
    auth_uri          => "http://${keystone_host}:5000/v2.0",
    keystone_tenant   => 'services',
    keystone_user     => 'glance',
    keystone_password => $keystone_glance_password,
    sql_connection    => $glance_api_database,
    use_syslog        => true,
    enabled           => true,
    require           => Dc_mariadb::Db[$glance_api_db],
  }
  contain 'glance::api'

  exported_vars::set { 'glance_api_server':
    value => "${::fqdn}:${glance_port}",
  }

  class { 'glance::registry':
    auth_type         => 'keystone',
    auth_host         => $keystone_host,
    auth_uri          => "http://${keystone_host}:5000/v2.0",
    keystone_tenant   => 'services',
    keystone_user     => 'glance',
    keystone_password => $keystone_glance_password,
    sql_connection    => $glance_reg_database,
    use_syslog        => true,
    enabled           => true,
    require           => Dc_mariadb::Db[$glance_reg_db],
  }
  contain 'glance::registry'

  # TODO: Temporary backend while boot-strapping CEPH
  contain glance::backend::file

  @@keystone_endpoint { "${os_region}/glance":
    ensure        => present,
    public_url    => "http://${::fqdn}:${glance_port}",
    admin_url     => "http://${::fqdn}:${glance_port}",
    internal_url  => "http://${::fqdn}:${glance_port}",
    tag           => 'glance_endpoint',
  }

}

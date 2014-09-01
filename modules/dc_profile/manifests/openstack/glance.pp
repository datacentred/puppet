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

  $keystone_glance_password = hiera(keystone_glance_password)

  $os_region = hiera(os_region)

  $glance_api_db      = hiera(glance_api_db)
  $glance_api_db_user = hiera(glance_api_db_user)
  $glance_api_db_pass = hiera(glance_api_db_pass)
  $glance_api_db_host = hiera(glance_api_db_host)

  $glance_reg_db      = hiera(glance_reg_db)
  $glance_reg_db_user = hiera(glance_reg_db_user)
  $glance_reg_db_pass = hiera(glance_reg_db_pass)
  $glance_reg_db_host = hiera(glance_reg_db_host)

  # OpenStack API endpoint
  $osapi_public  = 'openstack.datacentred.io'

  $glance_port = '9292'

  $glance_api_database = "mysql://${glance_api_db_user}:${glance_api_db_pass}@${glance_api_db_host}/${glance_api_db}"
  $glance_reg_database = "mysql://${glance_reg_db_user}:${glance_reg_db_pass}@${glance_reg_db_host}/${glance_reg_db}"

  class { 'glance::api':
    registry_host            => $osapi_public,
    registry_client_protocol => 'https',
    auth_type                => 'keystone',
    auth_host                => $osapi_public,
    auth_protocol            => 'https',
    auth_uri                 => "https://${osapi_public}:5000/v2.0",
    keystone_tenant          => 'services',
    keystone_user            => 'glance',
    keystone_password        => $keystone_glance_password,
    sql_connection           => $glance_api_database,
    use_syslog               => true,
    enabled                  => true,
  }
  contain 'glance::api'

  # Export variable for use by haproxy to front this
  # API endpoint
  exported_vars::set { 'glance_api':
    value => $::fqdn,
  }

  class { 'glance::registry':
    auth_type         => 'keystone',
    auth_host         => $osapi_public,
    auth_uri          => "https://${osapi_public}:5000/v2.0",
    auth_protocol     => 'https',
    keystone_tenant   => 'services',
    keystone_user     => 'glance',
    keystone_password => $keystone_glance_password,
    sql_connection    => $glance_reg_database,
    use_syslog        => true,
    enabled           => true,
  }
  contain 'glance::registry'

  # TODO: Temporary backend while boot-strapping CEPH
  contain glance::backend::file

  @@keystone_endpoint { "${os_region}/glance":
    ensure        => present,
    public_url    => "https://${osapi_public}:${glance_port}",
    admin_url     => "https://${osapi_public}:${glance_port}",
    internal_url  => "https://${osapi_public}:${glance_port}",
    tag           => 'glance_endpoint',
  }

  include dc_icinga::hostgroup_glance

  # Logstash config
  if $::environment == 'production' {
    include dc_profile::openstack::glance_logstash
  }

}

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

  # OpenStack API and loadbalancer endpoint
  $osapi_public  = 'compute.datacentred.io'

  $glance_api_db      = hiera(glance_api_db)
  $glance_api_db_user = hiera(glance_api_db_user)
  $glance_api_db_pass = hiera(glance_api_db_pass)
  $glance_api_db_host = $osapi_public

  $glance_reg_db      = hiera(glance_reg_db)
  $glance_reg_db_user = hiera(glance_reg_db_user)
  $glance_reg_db_pass = hiera(glance_reg_db_pass)
  $glance_reg_db_host = $osapi_public

  $glance_api_database = "mysql://${glance_api_db_user}:${glance_api_db_pass}@${glance_api_db_host}/${glance_api_db}"
  $glance_reg_database = "mysql://${glance_reg_db_user}:${glance_reg_db_pass}@${glance_reg_db_host}/${glance_reg_db}"

  $management_ip = $::ipaddress_eth0

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
    database_connection      => $glance_api_database,
    use_syslog               => true,
    enabled                  => true,
  }
  contain 'glance::api'

  class { 'glance::registry':
    auth_type           => 'keystone',
    auth_host           => $osapi_public,
    auth_uri            => "https://${osapi_public}:5000/v2.0",
    auth_protocol       => 'https',
    keystone_tenant     => 'services',
    keystone_user       => 'glance',
    keystone_password   => $keystone_glance_password,
    database_connection => $glance_reg_database,
    use_syslog          => true,
    enabled             => true,
  }
  contain 'glance::registry'

  # Add this node into our loadbalancers
  @@haproxy::balancermember { "${::fqdn}-glance-registry":
    listening_service => 'glance-registry',
    server_names      => $::hostname,
    ipaddresses       => $management_ip,
    ports             => '9191',
    options           => 'check inter 2000 rise 2 fall 5',
  }
  @@haproxy::balancermember { "${::fqdn}-glance-api":
    listening_service => 'glance-api',
    server_names      => $::hostname,
    ipaddresses       => $management_ip,
    ports             => '9292',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # TODO: Temporary backend while boot-strapping CEPH
  contain glance::backend::file

  # include dc_icinga::hostgroup_glance

  # if $::environment == 'production' {
  #   # Logstash config
  #   include dc_profile::openstack::glance_logstash
  # }

}

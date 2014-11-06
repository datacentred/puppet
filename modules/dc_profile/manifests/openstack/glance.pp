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

  $glance_db      = hiera(glance_db)
  $glance_db_user = hiera(glance_db_user)
  $glance_db_pass = hiera(glance_db_pass)
  $glance_db_host = $osapi_public

  $glance_database = "mysql://${glance_db_user}:${glance_db_pass}@${glance_db_host}/${glance_db}"

  $management_ip = $::ipaddress

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
    database_connection      => $glance_database,
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
    database_connection => $glance_database,
    use_syslog          => true,
    enabled             => true,
  }
  contain 'glance::registry'

  # Add this node into our loadbalancers
  @@haproxy::balancermember { "${::fqdn}-glance-registry":
    listening_service => 'icehouse-glance-registry',
    server_names      => $::hostname,
    ipaddresses       => $management_ip,
    ports             => '9191',
    options           => 'check inter 2000 rise 2 fall 5',
  }
  @@haproxy::balancermember { "${::fqdn}-glance-api":
    listening_service => 'icehouse-glance-api',
    server_names      => $::hostname,
    ipaddresses       => $management_ip,
    ports             => '9292',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  class { '::glance::backend::rbd':
    rbd_store_ceph_conf => '/etc/ceph/ceph.conf',
    rbd_store_user      => 'glance',
    rbd_store_pool      => 'glance',
    package_ensure      => 'present',
  }

  unless $::is_vagrant {
    include ::dc_nrpe::glance
    if $::environment == 'production' {
      include ::dc_profile::openstack::glance_logstash
      include ::dc_icinga::hostgroup_glance
    }
  }

}

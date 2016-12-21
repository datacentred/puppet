# Class: dc_profile::openstack::nova::control
#
# OpenStack Nova control components profile class
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::nova::control {

  include ::nova
  include ::nova::keystone::auth
  include ::nova::api
  include ::nova::network::neutron
  include ::nova::cert
  include ::nova::conductor
  include ::nova::consoleauth
  include ::nova::scheduler
  include ::nova::scheduler::filter
  include ::nova::vncproxy
  include ::dc_icinga::hostgroup_nova_server

  nova_config { 'DEFAULT/restrict_isolated_hosts_to_isolated_images':
    value => true,
  }

  # TODO: Use the actual ::nova::api parameter once we've upgraded puppet-nova
  nova_config { 'DEFAULT/secure_proxy_ssl_header':
    value => 'X-Forwarded-Proto',
  }

  nova_config { 'DEFAULT/osapi_compute_link_prefix':
    value => 'https://compute.datacentred.io:8774/',
  }

}

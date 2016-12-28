# Class: dc_profile::openstack::heat_db
#
# Openstack image API database definitions
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::heat {

  include ::heat
  include ::heat::engine
  include ::heat::api
  include ::heat::api_cfn

  # Install Keystone V2 plugin
  # Sourced from: https://github.com/openstack/heat/tree/master/contrib/rackspace/heat_keystoneclient_v2
  # TODO: Remove once we're on Keystone V3
  file { [ '/usr/lib/heat', '/usr/lib/heat/heat_keystoneclient_v2' ]:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { 'heat_keystone_v2_client.py':
    source  => 'puppet:///modules/dc_openstack/heat_client.py',
    path    => '/usr/lib/heat/heat_keystoneclient_v2/client.py',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/usr/lib/heat/heat_keystoneclient_v2'],
  }

  file { 'heat_keystone_v2_client_init.py':
    source  => 'puppet:///modules/dc_openstack/heat_init.py',
    path    => '/usr/lib/heat/heat_keystoneclient_v2/__init__.py',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/usr/lib/heat/heat_keystoneclient_v2'],
    notify  => Service['heat-engine'],
  }

  # Enable 'preview' Stack Adopt and Abandon features
  heat_config {
    'DEFAULT/stack_abandon'          : value => true;
    'DEFAULT/stack_adopt'            : value => true;
    'DEFAULT/keystone_backend'       : value => 'heat.engine.plugins.heat_keystoneclient_v2.client.KeystoneClientV2';
    'keystone_authtoken/auth_version': value => '2.0';
  }

}

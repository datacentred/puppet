# Class: dc_collectd::agent::openstack
#
# Puts the config in place for collectd's openstack modules
#
class dc_collectd::agent::openstack(
  $openstack_username,
  $openstack_password,
  $openstack_tenant,
  $openstack_authURL,
) {

  ensure_packages(['python-novaclient', 'python-glanceclient', 'python-cinderclient', 'python-keystoneclient', 'python-neutronclient'])

  class { 'collectd::plugin::python':
    modulepaths => ['/usr/lib/collectd/openstack'],
    modules     => {
      'keystone_plugin' => {
        'script_source' => 'puppet:///modules/dc_collectd/openstack/keystone_plugin.py',
        'config'        => {
          'Username'   => $openstack_username,
          'Password'   => $openstack_password,
          'TenantName' => $openstack_tenant,
          'AuthURL'    => "${openstack_authURL}",
          'Verbose'    => true,
        },
      },
      'cinder_plugin'   => {
        'script_source' => 'puppet:///modules/dc_collectd/openstack/cinder_plugin.py',
        'config'        => {
          'Username'   => $openstack_username,
          'Password'   => $openstack_password,
          'TenantName' => $openstack_tenant,
          'AuthURL'    => "${openstack_authURL}",
          'Verbose'    => true,
        },
      },
      'glance_plugin'   => {
        'script_source' => 'puppet:///modules/dc_collectd/openstack/glance_plugin.py',
        'config'        => {
          'Username'   => $openstack_username,
          'Password'   => $openstack_password,
          'TenantName' => $openstack_tenant,
          'AuthURL'    => "${openstack_authURL}",
          'Verbose'    => true,
        },
      },
      'neutron_plugin'  => {
        'script_source' => 'puppet:///modules/dc_collectd/openstack/neutron_plugin.py',
        'config'        => {
          'Username'   => $openstack_username,
          'Password'   => $openstack_password,
          'TenantName' => $openstack_tenant,
          'AuthURL'    => "${openstack_authURL}",
          'Verbose'    => true,
        },
      },
      'nova_plugin'     => {
        'script_source' => 'puppet:///modules/dc_collectd/openstack/nova_plugin.py',
        'config'        => {
          'Username'   => $openstack_username,
          'Password'   => $openstack_password,
          'TenantName' => $openstack_tenant,
          'AuthURL'    => "${openstack_authURL}",
          'Verbose'    => true,
        },
      },
    },
    logtraces   => true,
    interactive => false,
  }

}

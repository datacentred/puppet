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

  ensure_packages([python-novaclient, python-glanceclient, python-cinderclient, python-keystoneclient, python-neutronclient])

  file { '/usr/lib/collectd/openstack' :
    ensure  => directory,
    path    => '/usr/lib/collectd/openstack',
    require => Package['collectd'],
    source  => 'puppet:///modules/dc_collectd/openstack',
    recurse => true,
  }

  collectd::plugin::python { 'keystone':
    modulepath    => '/usr/lib/collectd/openstack',
    module        => 'keystone_plugin',
    script_source => 'puppet:///modules/dc_collectd/openstack/keystone_plugin.py',
    config        => {
      'Username'   => $openstack_username,
      'Password'   => $openstack_password,
      'TenantName' => $openstack_tenant,
      'AuthURL'    => $openstack_authURL,
      'Verbose'    => true,
    },
  }

  collectd::plugin::python { 'cinder':
    modulepath    => '/usr/lib/collectd/openstack',
    module        => 'cinder_plugin',
    script_source => 'puppet:///modules/dc_collectd/openstack/cinder_plugin.py',
    config        => {
      'Username'   => $openstack_username,
      'Password'   => $openstack_password,
      'TenantName' => $openstack_tenant,
      'AuthURL'    => $openstack_authURL,
      'Verbose'    => true,
    },
  }

    collectd::plugin::python { 'glance':
    modulepath    => '/usr/lib/collectd/openstack',
    module        => 'glance_plugin',
    script_source => 'puppet:///modules/dc_collectd/openstack/glance_plugin.py',
    config        => {
      'Username'   => $openstack_username,
      'Password'   => $openstack_password,
      'TenantName' => $openstack_tenant,
      'AuthURL'    => $openstack_authURL,
      'Verbose'    => true,
    },
  }

    collectd::plugin::python { 'neutron':
    modulepath    => '/usr/lib/collectd/openstack',
    module        => 'neutron_plugin',
    script_source => 'puppet:///modules/dc_collectd/openstack/neutron_plugin.py',
    config        => {
      'Username'   => $openstack_username,
      'Password'   => $openstack_password,
      'TenantName' => $openstack_tenant,
      'AuthURL'    => $openstack_authURL,
      'Verbose'    => true,
    },
  }

    collectd::plugin::python { 'nova':
    modulepath    => '/usr/lib/collectd/openstack',
    module        => 'nova_plugin',
    script_source => 'puppet:///modules/dc_collectd/openstack/nova_plugin.py',
    config        => {
      'Username'   => $openstack_username,
      'Password'   => $openstack_password,
      'TenantName' => $openstack_tenant,
      'AuthURL'    => $openstack_authURL,
      'Verbose'    => true,
    },
  }

}

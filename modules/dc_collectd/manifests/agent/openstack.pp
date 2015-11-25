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

  file { '/usr/lib/collectd/openstack' :
    ensure  => directory,
    path    => '/usr/lib/collectd/openstack',
    require => Package['collectd'],
  }

  Collectd::Plugin::Python::Module {
    modulepath => '/usr/lib/collectd/openstack',
    require    => File['/usr/lib/collectd/openstack'],
    config        => {
      'Username'   => $openstack_username,
      'Password'   => $openstack_password,
      'TenantName' => $openstack_tenant,
      'AuthURL'    => $openstack_authURL,
      'Verbose'    => true,
    },
  }

  collectd::plugin::python::module { 'keystone':
    module        => 'keystone_plugin',
    script_source => 'puppet:///modules/dc_collectd/openstack/keystone_plugin.py',
  }

  collectd::plugin::python::module { 'cinder':
    module        => 'cinder_plugin',
    script_source => 'puppet:///modules/dc_collectd/openstack/cinder_plugin.py',
  }

  collectd::plugin::python::module { 'glance':
    module        => 'glance_plugin',
    script_source => 'puppet:///modules/dc_collectd/openstack/glance_plugin.py',
  }

  collectd::plugin::python::module { 'neutron':
    module        => 'neutron_plugin',
    script_source => 'puppet:///modules/dc_collectd/openstack/neutron_plugin.py',
  }

  collectd::plugin::python::module { 'nova':
    module        => 'nova_plugin',
    script_source => 'puppet:///modules/dc_collectd/openstack/nova_plugin.py',
  }

}

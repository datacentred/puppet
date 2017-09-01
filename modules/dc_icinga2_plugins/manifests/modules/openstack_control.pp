# == Class: dc_icinga2_plugins::modules::openstack_control
#
# Plugins/packages for the oscontrol nodes
#
class dc_icinga2_plugins::modules::openstack_control {

  dc_icinga2_plugins::module { 'openstack_control':
    plugins      => [
      'check_heat',
    ],
    pip_packages => [
      'keystoneauth1',
      'python-heatclient',
    ],
  }

}

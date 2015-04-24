# Class: dc_branding::openstack::horizon
#
# Apply a branding override to horizon
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_branding::openstack::horizon (
  $horizon_path = '/usr/share/openstack-dashboard',
  $theme_path   = '/usr/share/openstack-dashboard-datacentred-theme',
) {

  File {
    owner  => 'root',
    group  => 'root',
    notify => Service['apache2'],
  }

  # Add in the resources
  file { $theme_path:
    ensure  => directory,
    source  => 'puppet:///modules/dc_branding/openstack-dashboard-datacentred-theme',
    recurse => true,
    purge   => true,
  }

  # Create the configuration file
  file { '/etc/openstack-dashboard/datacentred_theme.py':
    ensure  => file,
    content => "TEMPLATE_DIRS = ('${theme_path}/templates', )",
  }

  # Link resources into the horizon install
  file { "${horizon_path}/openstack_dashboard/local/datacentred_theme.py":
    ensure => link,
    target => '/etc/openstack-dashboard/datacentred_theme.py',
  }

  file { "${horizon_path}/openstack_dashboard/static/datacentred":
    ensure => link,
    target => "${theme_path}/static/datacentred",
  }

}

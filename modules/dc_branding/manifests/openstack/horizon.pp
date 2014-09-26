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
  $files_path   = 'dc_branding/openstack/horizon',
) {

  File {
    owner => 'root',
    group => 'root',
  }

  # Create our directory structure
  file { [
    $theme_path,
    "${theme_path}/static",
    "${theme_path}/static/datacentred",
  ]:
    ensure => directory,
    mode   => '0755',
  }

  # Add in the resources
  file { "${theme_path}/static/datacentred/css":
    ensure  => directory,
    source  => "puppet:///modules/${files_path}/css",
    recurse => true,
    require => File["${theme_path}/static/datacentred"],
  }

  file { "${theme_path}/static/datacentred/img":
    ensure  => directory,
    source  => "puppet:///modules/${files_path}/img",
    recurse => true,
    require => File["${theme_path}/static/datacentred"],
  }

  file { "${theme_path}/templates":
    ensure  => directory,
    source  => "puppet:///modules/${files_path}/templates",
    recurse => true,
    require => File[$theme_path],
  }

  # Create the configuration file
  file { '/etc/openstack-dashboard/datacentred_theme.py':
    ensure  => file,
    content => template("${files_path}/datacentred_theme.py.erb"),
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

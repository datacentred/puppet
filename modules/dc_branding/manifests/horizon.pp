# == Class: dc_branding::horizon
#
# Apply DataCentred branding to Horizon
#
# === Notes
#
# Compatible with OpenStack Kilo or greater
#
class dc_branding::horizon {

  $horizon_dir = '/usr/share/openstack-dashboard'
  $theme_dir = '/usr/share/openstack-dashboard-datacentred-theme'

  package { 'openstack-dashboard-ubuntu-theme':
    ensure => absent,
  } ->

  file { $theme_dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    recurse => true,
    purge   => true,
    force   => true,
    source  => 'puppet:///modules/dc_branding/horizon',
  } ->

  file { "${horizon_dir}/openstack_dashboard/static/themes/datacentred":
    ensure => link,
    target => $theme_dir,
  } ->

  exec { 'dc_branding::horizon collect':
    cwd         => $horizon_dir,
    command     => 'python manage.py collectstatic --noinput',
    refreshonly => true,
  } ->

  exec { 'dc_branding::horizon compress':
    cwd         => $horizon_dir,
    command     => 'python manage.py compress --force',
    refreshonly => true,
  }

  # Ensure horizon (and implicitly openstack-dashboard-ubuntu-theme) are
  # installed before removing ubuntu branding and configuring the new one,
  # this will deconfigure the existing theme first
  Package['openstack-dashboard'] -> Class['dc_branding::horizon']

  # Perform the collection and compression only after the configuration file
  # is generated
  File['/etc/openstack-dashboard/local_settings.py'] -> Exec['dc_branding::horizon collect']

  # Ensure we collect and compress only on changes to the branding resources
  File[$theme_dir] ~> Exec['dc_branding::horizon collect']
  File[$theme_dir] ~> Exec['dc_branding::horizon compress']

  # Restart the webserver on creation of new static resources
  Exec['dc_branding::horizon compress'] ~> Service['apache2']

}

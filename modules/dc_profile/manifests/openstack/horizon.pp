# == Class: dc_profile::openstack::horizon
#
class dc_profile::openstack::horizon {

  $containers = hiera('containers')

  dc_docker::run { 'horizon':
    * => $containers['horizon']
  }

  ensure_packages([ 'openstack-dashboard','openstack-dashboard-ubuntu-theme',
                    'python-django-horizon'], { ensure => absent })

}

# == Class: dc_profile::openstack::glance
#
# OpenStack image service
#
# NB: Ceph client configuration lives in a seperate profile class
#
class dc_profile::openstack::glance {

  include ::glance::keystone::auth
  include ::glance::api
  include ::glance::registry
  include ::glance::notify::rabbitmq
  include ::glance::cache::pruner
  include ::glance::cache::cleaner
  include ::glance::policy
  include ::glance::config
  include ::dc_icinga::hostgroup_glance

  # TODO: Remove post-upgrade
  file_line { 'glance_api_auth_version':
    ensure => absent,
    path   => '/etc/glance/glance-api.conf',
    line   => 'auth_version=V2.0',
    notify => Service['glance-api'],
  }

  file_line { 'glance_registry_auth_version':
    ensure => absent,
    path   => '/etc/glance/glance-registry.conf',
    line   => 'auth_version=V2.0',
    notify => Service['glance-registry'],
  }

}

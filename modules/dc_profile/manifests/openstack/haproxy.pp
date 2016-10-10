# Class: dc_profile::openstack::haproxy
#
# Configures HAproxy with SSL support
# for the various OpenStack API endpoints
#
# Parameters:
#
# Actions:
#
# Requires: datacentred-haproxy, dev version of haproxy that
#           includes SSL support
#
# Sample Usage:
#
# TODO: Enable SSL endpoints once we've stood up the necessary
# infrastructure

class dc_profile::openstack::haproxy {

  include ::haproxy
  include ::dc_ssl::haproxy
  include ::dc_icinga::hostgroup_haproxy

  create_resources(haproxy::listen, hiera_hash('dc_profile::openstack::haproxy::listeners'))
  create_resources(haproxy::balancermember, hiera_hash('dc_profile::openstack::haproxy::balancermembers'))

  # Ensure HAProxy is restarted whenever SSL certificates are changed
  Class['dc_ssl::haproxy'] ~> Haproxy::Listen <||>

}

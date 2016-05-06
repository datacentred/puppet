# == Class: dc_profile::openstack::proxy
#
# Top level Openstack API Proxy
#
class dc_profile::openstack::proxy {

  contain dc_profile::openstack::proxyip
  contain dc_profile::openstack::haproxy
  contain dc_profile::openstack::keepalived

  Class['dc_profile::openstack::proxyip'] ~>
  Class['dc_profile::openstack::keepalived'] ~>
  Class['dc_profile::openstack::haproxy']

}

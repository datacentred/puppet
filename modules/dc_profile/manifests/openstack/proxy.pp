# == Class: dc_profile::openstack::proxy
#
# Top level Openstack API Proxy
#
class dc_profile::openstack::proxy {

  contain dc_profile::openstack::proxyip
  contain dc_profile::openstack::haproxy
  contain dc_profile::openstack::keepalived

  Class['Dc_profile::Openstack::Proxyip'] ~>
  Class['Dc_profile::Openstack::Keepalived'] ~>
  Class['Dc_profile::Openstack::Haproxy']

}

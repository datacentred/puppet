# Class: dc_role::osapi
#
# OpenStack API Front-End Server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::osapi {
  contain dc_profile::openstack::proxyip
  contain dc_profile::openstack::haproxy
  contain dc_profile::openstack::keepalived

  Class['Dc_profile::Openstack::Proxyip'] ~>
  Class['Dc_profile::Openstack::Keepalived'] ~>
  Class['Dc_profile::Openstack::Haproxy']
}

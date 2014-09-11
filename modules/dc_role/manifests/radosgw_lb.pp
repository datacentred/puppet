# == Class: dc_role::radosgw_lb
#
# Keepalived and HA Proxy load balancers for rados gateways
#
class dc_role::radosgw_lb {

  include ::dc_profile::ceph::radosgw_lb
  contain dc_profile::ceph::radosgw_lb

}

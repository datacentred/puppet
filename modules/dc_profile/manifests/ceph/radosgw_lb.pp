# == Class: dc_profile::ceph::radosgw_lb
#
# Provide a load balancer across the set of gateways
#
class dc_profile::ceph::radosgw_lb {

  # Parameters are provided on a per node basis we should think
  # about role based configuration to offer shared config
  include ::loadbalancer

}

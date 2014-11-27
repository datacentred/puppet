# == Class: dc_profile::ceph::radosgw_lb
#
class dc_profile::ceph::radosgw_lb {

  include ::dc_ssl::storage
  include ::loadbalancer::certs
  include ::loadbalancer

  Class['dc_ssl::storage'] ->
  Class['loadbalancer::certs'] ->
  Class['loadbalancer']

}

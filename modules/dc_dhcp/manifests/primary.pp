# == Class: dc_dhcp::primary
#
# Installs the dhcp synchronisation agent on the dhcp master node
#
class dc_dhcp::primary {

  include ::dc_dhcp
  include ::dc_dhcp::primary::install
  include ::dc_dhcp::primary::config
  include ::dc_dhcp::primary::service

  Class['dc_dhcp'] ->
  Class['dc_dhcp::primary::install'] ->
  Class['dc_dhcp::primary::config'] ~>
  Class['dc_dhcp::primary::service']

}

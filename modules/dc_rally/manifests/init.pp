# Class: dc_rally
#
# Installs Rally and Tempest: https://wiki.openstack.org/wiki/Rally
#
class dc_rally {

  anchor { 'dc_rally::begin': } ->
  class { '::dc_rally::install': } ->
  class { '::dc_rally::config': } ->
  class { '::dc_rally::schedule': } ->
  anchor { 'dc_rally::end': }

}

# == Class: dc_profile::puppet::puppet_ca
#
# Class add in CA specific stuff e.g. certificate management and backups
#
class dc_profile::puppet::puppet_ca {

  include ::dc_foreman_proxy
  include ::dc_icinga::hostgroup_foreman_proxy

  # NOTE: Implies a CA is a master
  # NOTE: Foreman interferes with CA generation if a master is
  #       not installed first, so knee cap it
  Class['::puppet::master'] -> Class['::dc_foreman_proxy']

}
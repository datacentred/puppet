# == Class: dc_profile::openstack::network
#
# Top level network node profile
#
class dc_profile::openstack::network {

  contain dc_profile::openstack::neutron_agent

  include dc_icinga::hostgroup_neutron_node

  if $::osfamily == 'RedHat' {
    service { 'firewalld':
      ensure => 'stopped',
    }
    service { 'NetworkManager':
      ensure => 'stopped',
    }
  }

}

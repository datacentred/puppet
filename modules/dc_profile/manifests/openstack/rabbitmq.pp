# Class: dc_profile::openstack::rabbitmq
#
# Install and configure a RabbitMQ cluster with mirrored queues
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::rabbitmq {

  $osdbmq_rabbitmq_user = hiera(osdbmq_rabbitmq_user)
  $osdbmq_rabbitmq_pw = hiera(osdbmq_rabbitmq_pw)

  $management_ip = $::ipaddress

  # Return just the hostname from the FQDN stored in Hiera
  $cluster_nodes = regsubst(hiera(osdbmq_members), '\.(.*)', '', 'G')

  # We need one of our nodes to be a 'disc' cluster node,
  # the rest should be 'ram'
  $disc_cluster_node = $cluster_nodes[0]

  if $::hostname == $disc_cluster_node {
    $cluster_node_type = 'disc'
  } else {
    $cluster_node_type = 'ram'
  }

  # rabbitmq application account needs puppet group
  # membership in order to use the latter's SSL keys
  user { 'rabbitmq':
    ensure     => present,
    groups     => 'puppet',
    home       => '/srv/rabbitmq',
    managehome => true,
    system     => true,
  } ->
  file { '/var/lib/rabbitmq':
    ensure => link,
    target => '/srv/rabbitmq',
  } ->
  file { '/srv/rabbitmq/mnesia':
    ensure => directory,
    owner  => 'rabbitmq',
    group  => 'rabbitmq',
  } ->
  class { '::rabbitmq':
    cluster_nodes     => $cluster_nodes,
    cluster_node_type => $cluster_node_type,
  }
  contain ::rabbitmq

  exec { 'configure-ha-queue-policy':
    command => '/usr/sbin/rabbitmqctl set_policy HA \'^(?!amq\\.).*\' \'{"ha-mode": "all"}\'',
    require => Class['::rabbitmq'],
    unless  => '/usr/sbin/rabbitmqctl list_policies | grep -q HA',
  }

  rabbitmq_user { $osdbmq_rabbitmq_user:
    admin    => true,
    password => $osdbmq_rabbitmq_pw,
    require  => Class['::rabbitmq'],
  }

  rabbitmq_user_permissions { "${osdbmq_rabbitmq_user}@/":
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

  # Icinga checks
  include dc_icinga::hostgroup_rabbitmq

}

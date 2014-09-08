# Class: dc_profile::openstack::nova_mq
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

  class { '::rabbitmq':
    wipe_db_on_cookie_change => true,
    config_cluster           => true,
    admin_enable             => true,
    cluster_nodes            => $cluster_nodes,
    cluster_node_type        => $cluster_node_type,
  }

  exec { 'configure-ha-queue-policy':
    command     => '/usr/sbin/rabbitmqctl set_policy HA \'^(?!amq\\.).*\' \'{"ha-mode": "all"}\'',
    require     => Class['::rabbitmq'],
  }

}

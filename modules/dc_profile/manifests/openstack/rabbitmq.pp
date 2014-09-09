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

  $osdbmq_rabbitmq_user = hiera(osdbmq_rabbitmq_user)
  $osdbmq_rabbitmq_pw = hiera(osdbmq_rabbitmq_pw)

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

  # Sit our message queues on some SSD shiz
  file { '/srv/rabbitmq':
    ensure  => directory,
    recurse => true,
  }

  file { '/var/lib/rabbitmq':
    ensure  => link,
    target  => '/srv/rabbitmq',
    require => File['/srv/rabbitmq'],
  }

  class { '::rabbitmq':
    wipe_db_on_cookie_change => true,
    config_cluster           => true,
    admin_enable             => true,
    cluster_nodes            => $cluster_nodes,
    cluster_node_type        => $cluster_node_type,
    delete_guest_user        => true,
    ssl                      => true,
    ssl_cacert               => '/var/lib/puppet/ssl/certs/ca.pem',
    ssl_cert                 => "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
    ssl_key                  => "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
    ssl_verify               => true,
    ssl_fail_if_no_peer_cert => true,
    require                  => File['/srv/rabbitmq'],
  }

  rabbitmq_user { $osdbmq_rabbitmq_user:
    admin    => true,
    password => $osdbmq_rabbitmq_pw,
  }

  exec { 'configure-ha-queue-policy':
    command => '/usr/sbin/rabbitmqctl set_policy HA \'^(?!amq\\.).*\' \'{"ha-mode": "all"}\'',
    unless  => '/usr/sbin/rabbitmqctl list_policies -p HA',
    require => Class['::rabbitmq'],
  }

}

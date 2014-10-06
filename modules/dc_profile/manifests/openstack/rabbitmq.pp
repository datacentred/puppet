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
    ensure  => link,
    target  => '/srv/rabbitmq',
    require => User['rabbitmq'],
  } ->
  file { '/srv/rabbitmq/mnesia':
    ensure  => directory,
    owner   => 'rabbitmq',
    group   => 'rabbitmq',
    require => User['rabbitmq'],
  } ->
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
    ssl_verify               => 'verify_peer',
    ssl_fail_if_no_peer_cert => true,
    environment_variables    => {
        'RABBITMQ_NODE_IP_ADDRESS' => $management_ip,
        'RABBITMQ_MNESIA_BASE'     => '/srv/rabbitmq',
        'RABBITMQ_MNESIA_DIR'      => "/srv/rabbitmq/${::hostname}",
    }
  } ~>
  exec { 'configure-ha-queue-policy':
    command => '/usr/sbin/rabbitmqctl set_policy HA \'^(?!amq\\.).*\' \'{"ha-mode": "all"}\'',
    require => Class['::rabbitmq'],
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

}

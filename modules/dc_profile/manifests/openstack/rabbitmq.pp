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

  $rabbitmq_monuser = hiera(rabbitmq_monuser)
  $rabbitmq_monuser_password = hiera(rabbitmq_monuser_password)

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

  # Export our haproxy balancermember resource
  @@haproxy::balancermember { "${::fqdn}-rabbitmq":
    listening_service => 'rabbitmq',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '5672',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Icinga checks
  unless $::is_vagrant {
    include ::dc_icinga::hostgroup_rabbitmq
    include ::dc_logstash::client::rabbitmq
    # Required for Icinga monitoring
    rabbitmq_user { $rabbitmq_monuser:
      admin    => true,
      password => $rabbitmq_monuser_password,
      require  => Class['::rabbitmq'],
    }
  }

}

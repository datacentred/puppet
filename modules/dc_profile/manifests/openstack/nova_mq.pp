# Class: dc_profile::openstack::nova_mq
#
# Installs a HA rabbitmq node onto the network
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::nova_mq {

  $nova_mq_username = hiera(nova_mq_username)
  $nova_mq_password = hiera(nova_mq_password)
  $nova_mq_port     = hiera(nova_mq_port)
  $nova_mq_vhost    = hiera(nova_mq_vhost)

  # Hard coded exported variable name
  $nova_mq_ev = 'nova_mq_node'

  # Export a variable to say we're part of a nova_mq cluster
  exported_vars::set { $nova_mq_ev:
    value => "${::fqdn}",
  }

  # Create the MQ with the openstack user and password
  # 'cluster_disk_nodes' expects an array so ensure the
  # default is valid for the first run
  class { 'nova::rabbitmq':
    userid             => $nova_mq_username,
    password           => $nova_mq_password,
    port               => $nova_mq_port,
    virtual_host       => $nova_mq_vhost,
    cluster_disk_nodes => get_exported_var('', $nova_mq_ev, ['localhost']),
  }
  contain 'nova::rabbitmq'

  include dc_icinga::hostgroups
  realize Dc_external_facts::Fact['dc_hostgroup_rabbitmq']

  class { 'dc_profile::mon::rabbitmq_monuser':
    userid   => $rabbitmq_monuser,
    password => $rabbitmq_monuser_password,
    vhost    => $nova_mq_vhost,
  }

  include dc_collectd::agent::rabbitmq

  include dc_profile::openstack::nova_mq_logstash

}

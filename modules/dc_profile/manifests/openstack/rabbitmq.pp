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

  include ::rabbitmq

  $osdbmq_rabbitmq_user = hiera(osdbmq_rabbitmq_user)
  $osdbmq_rabbitmq_pw = hiera(osdbmq_rabbitmq_pw)

  # The 'rabbitmq' application account needs puppet group membership in order
  # to use the latter's SSL keys
  user { 'rabbitmq':
    ensure     => present,
    groups     => 'puppet',
    home       => '/srv/rabbitmq',
    managehome => true,
    system     => true,
  }

  file { ['/srv/rabbitmq', '/srv/rabbitmq/mnesia']:
    ensure  => directory,
    owner   => 'rabbitmq',
    group   => 'rabbitmq',
    require => User['rabbitmq'],
  }

  file { '/var/lib/rabbitmq':
    ensure  => link,
    target  => '/srv/rabbitmq',
    require => File['/srv/rabbitmq'],
  }

  exec { 'configure-ha-queue-policy':
    command => '/usr/sbin/rabbitmqctl set_policy HA \'^(?!amq\\.).*\' \'{"ha-mode": "all"}\'',
    unless  => '/usr/sbin/rabbitmqctl list_policies | grep -q HA',
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
    require              => Rabbitmq_User[$osdbmq_rabbitmq_user],
  }

  unless $::is_vagrant {
    include ::dc_icinga::hostgroup_rabbitmq
    rabbitmq_user { 'monitor':
      admin    => true,
      password => hiera(rabbitmq_monuser_password),
      require  => Class['::rabbitmq'],
    }
  }

}

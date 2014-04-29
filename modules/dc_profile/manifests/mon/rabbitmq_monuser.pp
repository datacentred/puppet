class dc_profile::mon::rabbitmq_monuser (
  $userid       = 'monitor',
  $vhost = undef,
  $password = undef, ){

  include rabbitmq

  rabbitmq_user { $userid:
    admin    => false,
    password => $password,
    provider => 'rabbitmqctl',
    require  => Class['::rabbitmq'],
  }

  rabbitmq_user_permissions { "${userid}@${vhost}":
    configure_permission => '.*',
    write_permission     => '.*',
    read_permission      => '.*',
    provider             => 'rabbitmqctl',
  }

  exec { "${userid}_set_user_tags":
    command => "/usr/sbin/rabbitmqctl set_user_tags ${userid} monitoring",
    unless  => "rabbitmqctl list_users | grep ${userid} | grep -w monitoring",
    require => Class['::rabbitmq'],
  }

}

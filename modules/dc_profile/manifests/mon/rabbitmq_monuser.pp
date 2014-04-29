class dc_profile::mon::rabbitmq_monuser (
  $userid       = 'monitor',
  $virtual_host = undef,
  $password = undef, ){

  include rabbitmq

  rabbitmq_user { $userid:
    admin    => false,
    password => $password,
    provider => 'rabbitmqctl',
    require  => Class['::rabbitmq'],
  }

  rabbitmq_user_permissions { "${userid}@${virtual_host}":
    configure_permission => '.*',
    write_permission     => '.*',
    read_permission      => '.*',
    provider             => 'rabbitmqctl',
  }

  exec { "${userid}_set_user_tags":
    command => "/usr/sbin/rabbitmqctl set_user_tags ${userid} monitoring",
    unless  => "rabbitmqctl list_users | grep ${userid} | grep \[monitoring]",
    require => Class['::rabbitmq'],
  }

}

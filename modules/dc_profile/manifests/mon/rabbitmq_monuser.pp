class dc_profile::mon::rabbitmq_monuser (
  $userid       = 'monitor',
  $virtual_host = undef,
  $password = undef, ){

  include rabbitmq

  rabbitmq_user { $userid:
    admin     => false,
    password  => $password,
    provider  => 'rabbitmqctl',
    require   => Class['::rabbitmq'],
  }

  rabbitmq_user_permissions { "${userid}@${virtual_host}":
    configure_permission => '.*',
    write_permission     => '.*',
    read_permission      => '.*',
    provider             => 'rabbitmqctl',
  }

}

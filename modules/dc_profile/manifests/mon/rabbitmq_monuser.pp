class dc_profile::mon::rabbitmq_monuser (
  $userid       = 'monitor',
  $virtual_host = '/', ){

  include rabbitmq

  rabbitmq_user { $userid:
    admin     => false,
    password  => hiera(rabbitmq_monitor_password),
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

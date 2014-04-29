class dc_icinga::server::custom_plugins {

  File {
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

# Custom nagios plugins
  file { '/usr/lib/nagios/plugins/check_tftp':
    source => 'puppet:///modules/dc_icinga/check_tftp',
  }

  file { '/usr/lib/nagios/plugins/check_keystone':
    source => 'puppet:///modules/dc_icinga/check_keystone',
  }

  file { '/usr/lib/nagios/plugins/check_foreman':
    source => 'puppet:///modules/dc_icinga/check_foreman',
  }

  file { '/usr/lib/nagios/plugins/check_rabbitmq_aliveness':
    source => 'puppet:///modules/dc_icinga/check_rabbitmq_aliveness',
  }

  file { '/usr/lib/nagios/plugins/check_rabbitmq_objects':
    source => 'puppet:///modules/dc_icinga/check_rabbitmq_objects',
  }

  file { '/usr/lib/nagios/plugins/check_rabbitmq_overview':
    source => 'puppet:///modules/dc_icinga/check_rabbitmq_overview',
  }

  file { '/usr/lib/nagios/plugins/check_rabbitmq_partition':
    source => 'puppet:///modules/dc_icinga/check_rabbitmq_partition',
  }

  file { '/usr/lib/nagios/plugins/check_rabbitmq_queue':
    source => 'puppet:///modules/dc_icinga/check_rabbitmq_queue',
  }

  file { '/usr/lib/nagios/plugins/check_rabbitmq_server':
    source => 'puppet:///modules/dc_icinga/check_rabbitmq_server',
  }

  file { '/usr/lib/nagios/plugins/check_rabbitmq_shovels':
    source => 'puppet:///modules/dc_icinga/check_rabbitmq_shovels',
  }

  file { '/usr/lib/nagios/plugins/check_rabbitmq_watermark':
    source => 'puppet:///modules/dc_icinga/check_rabbitmq_watermark',
  }

}

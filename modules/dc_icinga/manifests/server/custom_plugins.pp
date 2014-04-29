class dc_icinga::server::custom_plugins {

# Custom nagios plugins
  file { '/usr/lib/nagios/plugins/check_tftp':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/dc_icinga/check_tftp',
  }

  file { '/usr/lib/nagios/plugins/check_keystone':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/dc_icinga/check_keystone',
  }

  file { '/usr/lib/nagios/plugins/check_foreman':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/dc_icinga/check_foreman',
  }

  file { '/usr/lib/nagios/plugins/check_rabbitmq_aliveness':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/dc_icinga/check_rabbitmq_aliveness',
  }

  file { '/usr/lib/nagios/plugins/check_rabbitmq_objects':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/dc_icinga/check_rabbitmq_objects',
  }

  file { '/usr/lib/nagios/plugins/check_rabbitmq_overview':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/dc_icinga/check_rabbitmq_overview',
  }

  file { '/usr/lib/nagios/plugins/check_rabbitmq_partition':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/dc_icinga/check_rabbitmq_partition',
  }

  file { '/usr/lib/nagios/plugins/check_rabbitmq_queue':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/dc_icinga/check_rabbitmq_queue',
  }

  file { '/usr/lib/nagios/plugins/check_rabbitmq_server':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/dc_icinga/check_rabbitmq_server',
  }

  file { '/usr/lib/nagios/plugins/check_rabbitmq_shovels':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/dc_icinga/check_rabbitmq_shovels',
  }

  file { '/usr/lib/nagios/plugins/check_rabbitmq_watermark':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/dc_icinga/check_rabbitmq_watermark',
  }

}

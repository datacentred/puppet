# Class: dc_openvas::config
#
# Installs and configures openvas scanner
#
class dc_openvas::config {

  include dc_openvas

  $_gsa_listen_address = hiera('dc_openvas::params::gsa_listen_address')
  $_gsa_listen_port = hiera('dc_openvas::params::gsa_listen_port')

  file { '/etc/default/openvas-gsa':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    content => template('dc_openvas/default.erb'),
    notify  => Service['openvas-gsa'],
  }

  file { '/etc/openvas/gsad_log.conf':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/dc_openvas/gsad_log.conf',
    notify => Service['openvas-gsa'],
  }

  file { '/etc/openvas/openvasmd_log.conf':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/dc_openvas/openvasmd_log.conf',
    notify => Service['openvas-manager'],
  }

  file { '/usr/local/bin/create_task.sh':
    ensure => file,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/dc_openvas/create_task.sh',
  }

  file { '/usr/local/bin/openvas_sync.sh':
    ensure => file,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/dc_openvas/openvas_sync.sh',
  }

  cron { 'openvas_sync':
    command => '/usr/local/bin/openvas_sync.sh 1>/dev/null',
    user    => root,
    hour    => 23,
    minute  => 0,
  }

  runonce { 'add_admin_user':
    command => "openvasmd --create-user=${::dc_openvas::gsa_user}"
  } ->
  runonce { 'set_user_password':
    command => "openvasmd --user=${::dc_openvas::gsa_user} --new-password=${::dc_openvas::gsa_password}"
  } ->
  runonce { 'delete_admin':
    command => 'openvasmd --delete-user=admin'
  }

  runonce { 'openvas_split_config':
    command => 'sed -i \'s/SPLIT_PART_SIZE=0/SPLIT_PART_SIZE=200/g\' /usr/sbin/openvas-scapdata-sync'
  } ->
  runonce { 'openvas_nvt_sync':
    command => '/usr/sbin/openvas-nvt-sync',
    timeout => 0,
  } ->
  runonce { 'openvas_scapdata_sync':
    command => '/usr/sbin/openvas-scapdata-sync',
    timeout => 0,
  } ->
  runonce { 'openvas_certdata_sync':
    command => '/usr/sbin/openvas-certdata-sync',
    timeout => 0,
    notify  => [ Service['openvas-scanner'], Service['openvas-manager'] ]
  }

  # openvasmd --rebuild --progress needs to be run manually
  # once install is completed as it doesn't work under puppet

  create_resources(dc_openvas::load_target, $dc_openvas::scan_targets)

  # lint:ignore:140chars
  exec { 'openvas_weekly_schedule':
    command => "omp -u ${::dc_openvas::gsa_user} \
    -w ${::dc_openvas::gsa_password} -X \
    \'<create_schedule><name>Weekly</name><first_time><hour>1</hour><minute>0</minute></first_time><period>1<unit>week</unit></period></create_schedule>\'",
    unless  => "omp -u ${::dc_openvas::gsa_user} -w ${::dc_openvas::gsa_password} -X \'<get_schedules filter=\"Weekly\"/>\' | grep \'schedule id=\'",
    require => Runonce['delete_admin'],
  }
  # lint:endignore

}


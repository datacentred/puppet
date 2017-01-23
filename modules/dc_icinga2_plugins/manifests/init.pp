# == Class: dc_icinga2_plugins
#
# Installs and manages bespoke icinga/nagios plugins
#
class dc_icinga2_plugins (
  $packages     = $::dc_icinga2_plugins::params::packages,
  $pip_packages = $::dc_icinga2_plugins::params::pip_packages,
) inherits ::dc_icinga2_plugins::params {

  File {
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { [
    '/usr/local/lib/nagios',
    '/usr/local/lib/nagios/plugins',
  ]:
    ensure => directory,
  }

  file { '/usr/local/lib/nagios/plugins/check_ceilometer_update':
    source => 'puppet:///modules/dc_icinga2_plugins/check_ceilometer_update',
  }

  file { '/usr/local/lib/nagios/plugins/check_ip_pool':
    source => 'puppet:///modules/dc_icinga2_plugins/check_ip_pool',
  }

  file { '/usr/local/lib/nagios/plugins/check_anti_affinity':
    source => 'puppet:///modules/dc_icinga2_plugins/check_anti_affinity',
  }

  file { '/usr/local/lib/nagios/plugins/antiaffinitycheck.py':
    ensure => absent,
  }

  file { '/usr/local/lib/nagios/plugins/check_bmc':
    source => 'puppet:///modules/dc_icinga2_plugins/check_bmc',
  }

  file { '/usr/local/lib/nagios/plugins/check_ceph_health':
    source => 'puppet:///modules/dc_icinga2_plugins/check_ceph_health',
  }

  file { '/usr/local/lib/nagios/plugins/check_ceph_mon':
    source => 'puppet:///modules/dc_icinga2_plugins/check_ceph_mon',
  }

  file { '/usr/local/lib/nagios/plugins/check_ceph_osd':
    source => 'puppet:///modules/dc_icinga2_plugins/check_ceph_osd',
  }

  file { '/usr/local/lib/nagios/plugins/check_ceph_rgw':
    source => 'puppet:///modules/dc_icinga2_plugins/check_ceph_rgw',
  }

  file { '/usr/local/lib/nagios/plugins/check_neutron_api':
    source => 'puppet:///modules/dc_icinga2_plugins/check_neutron_api',
  }

  file { '/usr/local/lib/nagios/plugins/check_neutron_agents':
    source => 'puppet:///modules/dc_icinga2_plugins/check_neutron_agents',
  }

  file { '/usr/local/lib/nagios/plugins/check_nova_agents':
    source => 'puppet:///modules/dc_icinga2_plugins/check_nova_agents',
  }

  file { '/usr/local/lib/nagios/plugins/check_openstack_service':
    source => 'puppet:///modules/dc_icinga2_plugins/check_openstack_service',
  }

  file { '/usr/local/lib/nagios/plugins/check_pgsql_replication':
    source => 'puppet:///modules/dc_icinga2_plugins/check_pgsql_replication',
  }

  file { '/usr/local/lib/nagios/plugins/check_psu':
    source => 'puppet:///modules/dc_icinga2_plugins/check_psu',
  }

  file { '/usr/local/lib/nagios/plugins/check_sas_phy':
    source => 'puppet:///modules/dc_icinga2_plugins/check_sas_phy',
  }

  file { '/usr/local/lib/nagios/plugins/check_ceph_memory':
    source => 'puppet:///modules/dc_icinga2_plugins/check_ceph_memory',
  }

  file { '/usr/local/lib/nagios/plugins/check_disk_queue':
    source => 'puppet:///modules/dc_icinga2_plugins/check_disk_queue',
  }

  file { '/usr/local/lib/nagios/plugins/check_disk_latency':
    source => 'puppet:///modules/dc_icinga2_plugins/check_disk_latency',
  }

  file { '/usr/local/lib/nagios/plugins/check_log_courier':
    source => 'puppet:///modules/dc_icinga2_plugins/check_log_courier',
  }

  file { '/usr/local/lib/nagios/plugins/check_memory_edac':
    source => 'puppet:///modules/dc_icinga2_plugins/check_memory_edac',
  }

  file { '/usr/local/lib/nagios/plugins/check_raid':
    source => 'puppet:///modules/dc_icinga2_plugins/check_raid',
  }

  file { '/usr/local/lib/nagios/plugins/check_active_users':
    source => 'puppet:///modules/dc_icinga2_plugins/check_active_users',
  }

  file { '/usr/local/lib/nagios/plugins/check_mtu':
    source => 'puppet:///modules/dc_icinga2_plugins/check_mtu',
  }

  file { '/usr/local/lib/nagios/plugins/check_haproxy':
    source => 'puppet:///modules/dc_icinga2_plugins/check_haproxy',
  }

  file { '/usr/local/lib/nagios/plugins/check_tftp':
    source => 'puppet:///modules/dc_icinga2_plugins/check_tftp',
  }

  file { '/usr/local/lib/nagios/plugins/check_interface':
    source => 'puppet:///modules/dc_icinga2_plugins/check_interface',
  }

  file { '/usr/local/lib/nagios/plugins/check_rabbitmq_aliveness':
    source => 'puppet:///modules/dc_icinga2_plugins/check_rabbitmq_aliveness',
  }

  file { '/usr/local/lib/nagios/plugins/check_rabbitmq_objects':
    source => 'puppet:///modules/dc_icinga2_plugins/check_rabbitmq_objects',
  }

  file { '/usr/local/lib/nagios/plugins/check_rabbitmq_overview':
    source => 'puppet:///modules/dc_icinga2_plugins/check_rabbitmq_overview',
  }

  file { '/usr/local/lib/nagios/plugins/check_rabbitmq_partitions':
    source => 'puppet:///modules/dc_icinga2_plugins/check_rabbitmq_partitions',
  }

  file { '/usr/local/lib/nagios/plugins/check_rabbitmq_server':
    source => 'puppet:///modules/dc_icinga2_plugins/check_rabbitmq_server',
  }

  file { '/usr/local/lib/nagios/plugins/check_rabbitmq_watermark':
    source => 'puppet:///modules/dc_icinga2_plugins/check_rabbitmq_watermark',
  }

  file { '/usr/local/lib/nagios/plugins/check_elasticsearch':
    source => 'puppet:///modules/dc_icinga2_plugins/check_elasticsearch',
  }

  file { '/usr/local/lib/nagios/plugins/check_mongodb':
    source => 'puppet:///modules/dc_icinga2_plugins/check_mongodb',
  }

  file { '/usr/local/lib/nagios/plugins/check_bmc_dns':
    source => 'puppet:///modules/dc_icinga2_plugins/check_bmc_dns',
  }

  file { '/usr/local/lib/nagios/plugins/check_keystone':
    source => 'puppet:///modules/dc_icinga2_plugins/check_keystone',
  }

  file { '/usr/local/lib/nagios/plugins/check_glance':
    source => 'puppet:///modules/dc_icinga2_plugins/check_glance',
  }

  file { '/usr/local/lib/nagios/plugins/check_cinder':
    source => 'puppet:///modules/dc_icinga2_plugins/check_cinder',
  }

  file { '/usr/local/lib/nagios/plugins/check_nova':
    source => 'puppet:///modules/dc_icinga2_plugins/check_nova',
  }

  file { '/usr/local/lib/nagios/plugins/check_ceilometer':
    source => 'puppet:///modules/dc_icinga2_plugins/check_ceilometer',
  }

  file { '/usr/local/lib/nagios/plugins/check_conntrack':
    source => 'puppet:///modules/dc_icinga2_plugins/check_conntrack',
  }

  ensure_packages($packages)

  ensure_packages($pip_packages, { 'provider' => 'pip' })

  Package['python-pip'] -> Package[$pip_packages]

}

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

  $plugins = [
    'check_active_users',
    'check_anti_affinity',
    'check_bmc',
    'check_bmc_dns',
    'check_ceilometer',
    'check_ceilometer_update',
    'check_ceph_health',
    'check_ceph_memory',
    'check_ceph_mon',
    'check_ceph_osd',
    'check_ceph_rgw',
    'check_cinder',
    'check_conntrack',
    'check_disk_latency',
    'check_disk_queue',
    'check_elasticsearch',
    'check_glance',
    'check_haproxy',
    'check_interface',
    'check_ip_pool',
    'check_keystone',
    'check_log_courier',
    'check_memory_edac',
    'check_mongodb',
    'check_mtu',
    'check_neutron_api',
    'check_neutron_agents',
    'check_nova',
    'check_nova_agents',
    'check_openstack_service',
    'check_pgsql_replication',
    'check_psu',
    'check_rabbitmq_aliveness',
    'check_rabbitmq_objects',
    'check_rabbitmq_overview',
    'check_rabbitmq_partitions',
    'check_rabbitmq_server',
    'check_rabbitmq_watermark',
    'check_raid',
    'check_routes',
    'check_sas_phy',
    'check_tftp',
  ]

  $plugins.each |$plugin| {
    file { "/usr/local/lib/nagios/plugins/${plugin}":
      content => file("dc_icinga2_plugins/${plugin}"),
    }
  }

  ensure_packages($packages)

  ensure_packages($pip_packages, { 'provider' => 'pip' })

  Package['python-pip'] -> Package[$pip_packages]

}

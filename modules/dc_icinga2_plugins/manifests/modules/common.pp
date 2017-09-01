# == Class: dc_icinga2_plugins::modules::common
#
# Common plugins for every host
#
class dc_icinga2_plugins::modules::common {

  dc_icinga2_plugins::module { 'common':
    plugins  => [
      'check_active_users',
      'check_anti_affinity',
      'check_bmc',
      'check_bmc_dns',
      'check_canary',
      'check_ceilometer',
      'check_ceilometer_update',
      'check_cinder',
      'check_conntrack',
      'check_disk_latency',
      'check_disk_queue',
      'check_elasticsearch',
      'check_glance',
      'check_haproxy',
      'check_interface',
      'check_ip_pool',
      'check_iptables',
      'check_keystone',
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
      'check_qemu_rlimit',
      'check_rabbitmq_aliveness',
      'check_rabbitmq_objects',
      'check_rabbitmq_overview',
      'check_rabbitmq_partitions',
      'check_rabbitmq_server',
      'check_rabbitmq_watermark',
      'check_raid',
      'check_routes',
      'check_sas_phy',
      'check_smart_proxy',
      'check_tftp',
    ],
    packages => [
      'python-ceilometerclient',
      'python-cinderclient',
      'python-glanceclient',
      'python-keystoneclient',
      'python-novaclient',
      'python-dnspython',
      'nagios-plugin-check-scsi-smart',
      'python-tftpy',
    ],
  }

}

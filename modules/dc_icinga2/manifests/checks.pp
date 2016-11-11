# == Class: dc_icinga2::checks
#
class dc_icinga2::checks {

  Icinga2::Object::Checkcommand {
    target => '/etc/icinga2/zones.d/global-templates/checks.conf',
  }

  icinga2::object::checkcommand { 'memory':
    command   => [
      'PluginDir + "/check_memory"',
    ],
    arguments => {
      '-w' => '$memory_warn_bytes$',
      '-c' => '$memory_critical_bytes$',
      '-u' => '$memory_unit$',
      '-t' => '$memory_timeout$',
    },
  }

  icinga2::object::checkcommand { 'sensors':
    command => [
      'PluginDir + "/check_sensors"',
    ],
  }

  icinga2::object::checkcommand { 'ip_pool':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_ip_pool"',
    ],
    arguments => {
      '-H' => '$ip_pool_host$',
      '-u' => '$ip_pool_user$',
      '-p' => '$ip_pool_password$',
      '-P' => '$ip_pool_project$',
      '-w' => '$ip_pool_percent_warn$',
      '-c' => '$ip_pool_percent_crit$',
    },
  }

  icinga2::object::checkcommand { 'ceilometer_update':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_ceilometer_update"',
    ],
    arguments => {
      '-H' => '$ceilometer_update_host$',
      '-u' => '$ceilometer_update_user$',
      '-p' => '$ceilometer_update_password$',
      '-P' => '$ceilometer_update_project$',
      '-w' => '$ceilometer_update_minutes_warn$',
      '-c' => '$ceilometer_update_minutes_crit$',
    },
  }

  icinga2::object::checkcommand { 'anti_affinity':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_anti_affinity"',
    ],
    arguments => {
      '-u' => '$anti_affinity_user$',
      '-p' => '$anti_affinity_password$',
      '-t' => '$anti_affinity_tenant_name$',
      '-a' => '$anti_affinity_auth_url$',
    },
    timeout   => '240',
  }

  icinga2::object::checkcommand { 'bmc':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_bmc"',
    ],
    arguments => {
      '-H' => '$bmc_host$',
      '-u' => '$bmc_username$',
      '-p' => '$bmc_password$',
      '-r' => '$bmc_revision$',
    },
  }

  icinga2::object::checkcommand { 'psu':
    command   => [
      '"sudo"',
      '"/usr/local/lib/nagios/plugins/check_psu"',
    ],
    arguments => {
      '-a' => '$psu_a_raw$',
      '-b' => '$psu_b_raw$',
    },
  }

  icinga2::object::checkcommand { 'ceph-health':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_ceph_health"',
    ],
    timeout   => 120,
    arguments => {
      '-e' => '$ceph_health_exe$',
      '-c' => '$ceph_health_conf$',
      '-m' => '$ceph_helath_monaddress$',
      '-i' => '$ceph_health_id$',
      '-k' => '$ceph_health_keyring$',
      '-d' => {
        'set_if' => '$ceph_health_detail$',
      },
    },
    vars      => {
      'ceph_health_detail' => false,
    }
  }

  icinga2::object::checkcommand { 'ceph-mon':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_ceph_mon"',
    ],
    timeout   => 120,
    arguments => {
      '-e' => '$ceph_mon_exe$',
      '-c' => '$ceph_mon_conf$',
      '-m' => '$ceph_mon_monaddress$',
      '-i' => '$ceph_mon_id$',
      '-k' => '$ceph_mon_keyring$',
      '-I' => '$ceph_mon_monid$',
      '-H' => '$ceph_mon_monhost$',
    },
  }

  icinga2::object::checkcommand { 'ceph-osd':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_ceph_osd"',
    ],
    timeout   => 120,
    arguments => {
      '-e' => '$ceph_osd_exe$',
      '-c' => '$ceph_osd_conf$',
      '-m' => '$ceph_osd_monaddress$',
      '-i' => '$ceph_osd_id$',
      '-k' => '$ceph_osd_keyring$',
      '-H' => '$ceph_osd_host$',
      '-I' => '$ceph_osd_osdid$',
      '-o' => '$ceph_osd_out$',
    },
  }

  icinga2::object::checkcommand { 'ceph-rgw':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_ceph_rgw"',
    ],
    timeout   => 120,
    arguments => {
      '-e' => '$ceph_rgw_exe$',
      '-c' => '$ceph_rgw_conf$',
      '-i' => '$ceph_rgw_id$',
    },
  }

  icinga2::object::checkcommand { 'dc_smart':
    command   => [
      '"sudo"',
      'PluginDir + "/check_scsi_smart"',
    ],
    arguments => {
      '-d' => '$smart_device$',
      '-w' => '$smart_warning$',
      '-c' => '$smart_critical$',
    },
  }

  icinga2::object::checkcommand { 'dhcp_sudo':
    command   => [
      '"sudo"',
      'PluginDir + "/check_dhcp"',
    ],
    arguments => {
      '-s' => '$dhcp_serverip$',
      '-r' => '$dhcp_requestedip$',
      '-t' => '$dhcp_timeout$',
      '-i' => '$dhcp_interface$',
      '-m' => '$dhcp_mac$',
      '-u' => {
        'set_if' => '$dhcp_unicast$',
      },
    },
    vars      => {
      'dhcp_unicast' => false,
    },
  }

  icinga2::object::checkcommand { 'pgsql_replication':
    command   => [
      '"sudo"',
      '"/usr/local/lib/nagios/plugins/check_pgsql_replication"',
    ],
    arguments => {
      '-p' => '$pgsql_replication_password$',
      '-w' => '$pgsql_replication_warning$',
      '-c' => '$pgsql_replication_critical$',
    }
  }

  icinga2::object::checkcommand { 'openstack-service':
    command   => [
      '"sudo"',
      '"/usr/local/lib/nagios/plugins/check_openstack_service"',
    ],
    arguments => {
      '-p' => '$openstack_service_process$',
      '-c' => {
        'set_if' => '$openstack_service_child$',
      }
    },
  }

  icinga2::object::checkcommand { 'sas-phy':
    command => [
      '"/usr/local/lib/nagios/plugins/check_sas_phy"',
    ],
  }

  icinga2::object::checkcommand { 'ssl-cert':
    command   => [
      'PluginDir + "/check_ssl_cert"',
    ],
    arguments => {
      '-H' => '$ssl_cert_host$',
      '-A' => '$ssl_cert_noauth$',
      '-C' => '$ssl_cert_clientcert$',
      '-c' => '$ssl_cert_critical$',
      '-e' => '$ssl_cert_email$',
      '-f' => '$ssl_cert_file$',
      '-i' => '$ssl_cert_issuer$',
      '-n' => '$ssl_cert_cn$',
      '-N' => '$ssl_cert_hostcn$',
      '-o' => '$ssl_client_org$',
      '-p' => '$ssl_cert_port$',
      '-P' => '$ssl_cert_protocol$',
      '-s' => '$ssl_cert_selfsigned$',
      '-S' => '$ssl_cert_ssl$',
      '-r' => '$ssl_cert_rootcert$',
      '-t' => '$ssl_cert_timeout$',
      '-w' => '$ssl_cert_warning$',
    },
    vars      => {
      'ssl_cert_host'     => '$address$',
      'ssl_cert_rootcert' => '/etc/ssl/certs',
      'ssl_cert_warning'  => 28,
      'ssl_cert_critical' => 7,
    },
  }

  icinga2::object::checkcommand { 'neutron-api':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_neutron_api"',
    ],
    arguments => {
      '-a' => '$neutron_api_auth_url$',
      '-n' => '$neutron_api_url$',
      '-t' => '$neutron_api_tenant$',
      '-u' => '$neutron_api_username$',
      '-p' => '$neutron_api_password$',
      '-w' => '$neutron_api_warning$',
      '-c' => '$neutron_api_critical$',
    },
  }

  icinga2::object::checkcommand { 'ceph-memory':
    command => [
      '"/usr/local/lib/nagios/plugins/check_ceph_memory"',
    ],
  }

  icinga2::object::checkcommand { 'disk-queue':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_disk_queue"',
    ],
    arguments => {
      '-d' => '$disk_queue_device$',
      '-a' => '$disk_queue_average$',
      '-w' => '$disk_queue_warning$',
      '-c' => '$disk_queue_critical$',
    },
  }

  icinga2::object::checkcommand { 'disk-latency':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_disk_latency"',
    ],
    arguments => {
      '-d' => '$disk_latency_device$',
      '-w' => '$disk_latency_warning$',
      '-c' => '$disk_latency_critical$',
    },
  }

  icinga2::object::checkcommand { 'log-courier':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_log_courier"',
    ],
    arguments => {
      '-w' => '$log_courier_backlog_warning$',
      '-c' => '$log_courier_backlog_critical$',
    },
  }

  icinga2::object::checkcommand { 'memory-edac':
    command => [
      '"/usr/local/lib/nagios/plugins/check_memory_edac"',
    ],
  }

  icinga2::object::checkcommand { 'raid':
    command => [
      '"sudo"',
      '"/usr/local/lib/nagios/plugins/check_raid"',
    ],
  }

  icinga2::object::checkcommand { 'active-users':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_active_users"',
    ],
    arguments => {
      '-t' => {
        'set_if' => '$active_users_no_tty_logins$',
      },
      '-u' => '$active_users_allowed_users$',
      '-s' => '$active_users_allowed_subnets$',
    },
  }

  icinga2::object::checkcommand { 'mtu':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_mtu"',
    ],
    arguments => {
      '-i' => '$mtu_interface$',
      '-m' => '$mtu_mtu$',
    },
  }

  icinga2::object::checkcommand { 'haproxy':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_haproxy"',
    ],
    arguments => {
      '-H' => '$haproxy_host$',
      '-p' => '$haproxy_port$',
      '-u' => '$haproxy_url$',
      '-k' => '$haproxy_privatekey$',
      '-c' => '$haproxy_clientcert$',
      '-P' => '$haproxy_perfdata$',
    },
  }

  icinga2::object::checkcommand { 'tftp':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_tftp"',
    ],
    arguments => {
      '-H' => '$tftp_host$',
      '-p' => '$tftp_port$',
      '-u' => '$tftp_url$',
    },
  }

  icinga2::object::checkcommand { 'interface':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_interface"',
    ],
    arguments => {
      '-i' => '$interface_name$',
      '-a' => '$interface_address$',
      '-n' => '$interface_netmask$',
      '-m' => '$interface_macaddr$',
    },
  }

  icinga2::object::checkcommand { 'rabbitmq-aliveness':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_rabbitmq_aliveness"',
    ],
    arguments => {
      '-H' => '$rabbitmq_aliveness_host$',
      '-P' => '$rabbitmq_aliveness_port$',
      '-u' => '$rabbitmq_aliveness_username$',
      '-p' => '$rabbitmq_aliveness_password$',
      '-V' => '$rabbitmq_aliveness_vhost$',
    },
    vars      => {
      'rabbitmq_aliveness_host'  => 'localhost',
      'rabbitmq_aliveness_port'  => 15672,
      'rabbitmq_aliveness_vhost' => '/',
    },
  }

  icinga2::object::checkcommand { 'rabbitmq-objects':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_rabbitmq_objects"',
    ],
    arguments => {
      '-H' => '$rabbitmq_objects_host$',
      '-P' => '$rabbitmq_objects_port$',
      '-u' => '$rabbitmq_objects_username$',
      '-p' => '$rabbitmq_objects_password$',
    },
    vars      => {
      'rabbitmq_objects_host' => 'localhost',
      'rabbitmq_objects_port' => 15672,
    },
  }

  icinga2::object::checkcommand { 'rabbitmq-overview':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_rabbitmq_overview"',
    ],
    arguments => {
      '-H' => '$rabbitmq_overview_host$',
      '-P' => '$rabbitmq_overview_port$',
      '-u' => '$rabbitmq_overview_username$',
      '-p' => '$rabbitmq_overview_password$',
    },
    vars      => {
      'rabbitmq_overview_host' => 'localhost',
      'rabbitmq_overview_port' => 15672,
    },
  }

  icinga2::object::checkcommand { 'rabbitmq-partitions':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_rabbitmq_partitions"',
    ],
    arguments => {
      '-H' => '$rabbitmq_partitions_host$',
      '-P' => '$rabbitmq_partitions_port$',
      '-u' => '$rabbitmq_partitions_username$',
      '-p' => '$rabbitmq_partitions_password$',
      '-n' => '$rabbitmq_partitions_node$',
    },
    vars      => {
      'rabbitmq_partitions_host' => 'localhost',
      'rabbitmq_partitions_port' => 15672,
    },
  }

  icinga2::object::checkcommand { 'rabbitmq-server':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_rabbitmq_server"',
    ],
    arguments => {
      '-H' => '$rabbitmq_server_host$',
      '-P' => '$rabbitmq_server_port$',
      '-u' => '$rabbitmq_server_username$',
      '-p' => '$rabbitmq_server_password$',
      '-n' => '$rabbitmq_server_node$',
      '-w' => '$rabbitmq_server_warning$',
      '-c' => '$rabbitmq_server_critical$',
    },
    vars      => {
      'rabbitmq_server_host' => 'localhost',
      'rabbitmq_server_port' => 15672,
    },
  }

  icinga2::object::checkcommand { 'rabbitmq-watermark':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_rabbitmq_watermark"',
    ],
    arguments => {
      '-H' => '$rabbitmq_watermark_host$',
      '-P' => '$rabbitmq_watermark_port$',
      '-u' => '$rabbitmq_watermark_username$',
      '-p' => '$rabbitmq_watermark_password$',
      '-n' => '$rabbitmq_watermark_node$',
    },
    vars      => {
      'rabbitmq_watermark_host' => 'localhost',
      'rabbitmq_watermark_port' => 15672,
    },
  }

  icinga2::object::checkcommand { 'dc_elasticsearch':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_elasticsearch"',
    ],
    arguments => {
      '-H' => '$elasticsearch_host$',
      '-P' => '$elasticsearch_port$',
      '-i' => '$elasticsearch_index$',
      '-s' => '$elasticsearch_seconds$',
    },
  }

  icinga2::object::checkcommand { 'dc_mongodb':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_mongodb"',
    ],
    arguments => {
      '-H'              => '$mongodb_host$',
      '-P'              => '$mongodb_port$',
      '-u'              => '$mongodb_username$',
      '-p'              => '$mongodb_password$',
      '-W'              => '$mongodb_warning$',
      '-C'              => '$mongodb_critical$',
      '-A'              => '$mongodb_action$',
      '--max-lag'       => {
        'set_if' => '$mongodb_max_lag$',
      },
      '--mapped-memory' => {
        'set_if' => '$mongodb_mapped_memory$',
      },
      '-D'              => {
        'set_if' => '$mongodb_perfdata$',
      },
      '-d'              => '$mongodb_database$',
      '--all-databases' => {
        'set_if' => '$mongodb_all_databases$',
      },
      '-s'              => {
        'set_if' => '$mongodb_ssl$',
      },
      '-r'              => {
        'set_if' => '$mongodb_replica_set$',
      },
      '-q'              => '$mongodb_query_type$',
      '-c'              => '$mongodb_collection$',
      '-T'              => '$mongodb_time$',
    },
    vars      => {
      'mongodb_perfdata' => true,
    },
  }

  icinga2::object::checkcommand { 'bmc_dns':
    command => [
      '"/usr/local/lib/nagios/plugins/check_bmc_dns"',
    ],
  }

  icinga2::object::checkcommand { 'keystone':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_keystone"',
    ],
    arguments => {
      '-H' => '$keystone_host$',
      '-r' => '$keystone_region$',
      '-P' => '$keystone_project$',
      '-u' => '$keystone_username$',
      '-p' => '$keystone_password$',
      '-a' => {
        'set_if' => '$keystone_admin$',
      },
      '-s' => '$keystone_service$',
    },
  }

  icinga2::object::checkcommand { 'glance':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_glance"',
    ],
    arguments => {
      '-H' => '$glance_host$',
      '-r' => '$glance_region$',
      '-P' => '$glance_project$',
      '-u' => '$glance_username$',
      '-p' => '$glance_password$',
      '-a' => '$glance_authurl$',
      '-w' => '$glance_warning$',
      '-c' => '$glance_critical$',
    },
  }

  icinga2::object::checkcommand { 'cinder':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_cinder"',
    ],
    timeout   => 240,
    arguments => {
      '-H' => '$cinder_host$',
      '-P' => '$cinder_project$',
      '-u' => '$cinder_username$',
      '-p' => '$cinder_password$',
      '-n' => '$cinder_volume_name$',
      '-s' => '$cinder_volume_size$',
      '-w' => '$cinder_warning$',
      '-c' => '$cinder_critical$',
      '-t' => '$cinder_timeout$',
    },
  }

  icinga2::object::checkcommand { 'nova':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_nova"',
    ],
    timeout   => 240,
    arguments => {
      '-H' => '$nova_host$',
      '-P' => '$nova_project$',
      '-u' => '$nova_username$',
      '-p' => '$nova_password$',
      '-f' => '$nova_flavor$',
      '-i' => '$nova_image$',
      '-n' => '$nova_network$',
      '-I' => '$nova_instance_name$',
      '-w' => '$nova_warning$',
      '-c' => '$nova_critical$',
      '-t' => '$nova_timeout$',
    },
  }

  icinga2::object::checkcommand { 'ceilometer':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_ceilometer"',
    ],
    arguments => {
      '-H' => '$ceilometer_host$',
      '-P' => '$ceilometer_project$',
      '-u' => '$ceilometer_username$',
      '-p' => '$ceilometer_password$',
      '-w' => '$ceilometer_warning$',
      '-c' => '$ceilometer_critical$',
    },
  }

  icinga2::object::checkcommand { 'conntrack':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_conntrack"',
    ],
    arguments => {
      '-w' => '$conntrack_warning$',
      '-c' => '$conntrack_critical$',
    },
  }

  icinga2::object::checkcommand { 'memcached':
    command   => [
      'PluginDir + "/check_memcached"',
    ],
    arguments => {
      '-H' => '$memcached_host$',
      '-p' => '$memcached_port$',
      '-v' => {
        'set_if' => '$memcached_verbose$',
      },
      '-n' => '$memcached_history$',
      '-T' => '$memcached_interval$',
      '-w' => '$memcached_warning_quotient$',
      '-E' => '$memcached_warning_evictions$',
      '-t' => '$memcached_timeout$',
      '-k' => '$memcached_keyname$',
      '-K' => '$memcached_expiry$',
      '-r' => {
        'set_if' => '$memcached_rate_per_minute$',
      },
    },
    vars      => {
      'memcached_host' => '$address$',
    },
  }

}

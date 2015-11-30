# == Class: dc_icinga::server::nagios_services
#
class dc_icinga::server::nagios_services {

  # Define services
  ######################################################################
  # These are the generic services that are locally monitored
  # via NRPE therefore must be defined in /etc/nagios/nrpe.cfg
  ######################################################################

  icinga::service { 'check_all_disks':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_generic',
    check_command       => 'check_nrpe_1arg!check_all_disks',
    service_description => 'Disk Space',
  }

  # Note: this service check installs an ELF binary
  icinga::service { 'check_dev_smart':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_x86',
    check_command       => 'check_nrpe_1arg!check_dev_smart',
    service_description => 'Hard Disk Health',
  }

  icinga::service { 'check_load':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_generic,!dc_hostgroup_nova_compute',
    check_command       => 'check_nrpe_1arg!check_load',
    service_description => 'Load Average',
  }

  icinga::service { 'check_users':
    use                 => 'dc_service_secondary',
    hostgroup_name      => 'dc_hostgroup_generic',
    check_command       => 'check_nrpe_1arg!check_users',
    service_description => 'Users',
  }

  icinga::service { 'check_procs':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_generic',
    check_command       => 'check_nrpe_1arg!check_total_procs',
    service_description => 'Processes',
  }

  icinga::service { 'check_puppetagent':
    use                 => 'dc_service_secondary',
    hostgroup_name      => 'dc_hostgroup_generic',
    check_command       => 'check_nrpe_1arg!check_puppetagent',
    service_description => 'Puppet Agent',
  }

  # Logstash

  icinga::service { 'check_logstashes':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_logstashes',
    check_command       => 'check_nrpe_1arg!check_logstashes',
    service_description => 'Logstash ES',
  }

  icinga::service { 'check_keystone':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_keystone',
    check_command       => 'check_keystone_dc',
    service_description => 'Keystone',
  }

  icinga::service { 'check_ssh':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_generic',
    check_command       => 'check_ssh',
    service_description => 'SSH',
  }

  icinga::service { 'check_http':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_http',
    check_command       => 'check_http',
    service_description => 'HTTP',
  }

  icinga::service { 'check_https':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_https',
    check_command       => 'check_https',
    service_description => 'HTTPS',
  }

  icinga::service { 'check_pgsql':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_postgres',
    check_command       => 'check_pgsql_dc!nagiostest!nagios!guweopojRut3',
    service_description => 'PostgreSQL',
  }

  icinga::service { 'check_dhcp':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_dhcp',
    check_command       => 'check_dhcp_by_mac!bond0',
    service_description => 'DHCP',
  }

  icinga::service { 'check_dns':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_dns',
    check_command       => 'check_dns',
    service_description => 'DNS',
  }

  icinga::service { 'check_ntp':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_ntp',
    check_command       => 'check_ntp_dc',
    service_description => 'NTP',
  }

  icinga::service { 'check_puppetdb':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_puppetdb',
    check_command       => 'check_nrpe_1arg!check_puppetdb',
    service_description => 'Puppet DB REST API',
  }

  icinga::service { 'check_foreman_proxy':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_foreman_proxy',
    check_command       => 'check_foreman_proxy_dc',
    service_description => 'Foreman Proxy REST API',
  }

  icinga::service { 'check_tftp':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_tftp',
    check_command       => 'check_tftp_dc',
    service_description => 'TFTP',
  }

  icinga::service { 'check_mysql':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_mysql',
    check_command       => 'check_mysql_dc',
    service_description => 'MySQL',
  }

  icinga::service { 'check_smtp':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_smtp',
    check_command       => 'check_smtp',
    service_description => 'SMTP',
  }

  icinga::service { 'check_postfix_queue':
    use                 => 'dc_service_secondary',
    hostgroup_name      => 'dc_hostgroup_postfix',
    check_command       => 'check_nrpe_1arg!check_mailq_postfix',
    service_description => 'Postfix Mail Queue',
  }

  icinga::service { 'check_neutron_dhcp_agent':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_neutron_node',
    check_command       => 'check_nrpe_1arg!check_neutron_dhcp_agent',
    service_description => 'Neutron DHCP Agent',
  }

  icinga::service { 'check_neutron_metadata_agent':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_neutron_node',
    check_command       => 'check_nrpe_1arg!check_neutron_metadata_agent',
    service_description => 'Neutron Metadata Agent',
  }

  icinga::service { 'check_neutron_vpn_agent':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_neutron_node',
    check_command       => 'check_nrpe_1arg!check_neutron_vpn_agent',
    service_description => 'Neutron VPN Agent',
  }

  icinga::service { 'check_neutron_lbaas_agent':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_neutron_node',
    check_command       => 'check_nrpe_1arg!check_neutron_lbaas_agent',
    service_description => 'Neutron LBAAS Agent',
  }

  icinga::service { 'check_neutron_metering_agent':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_neutron_node',
    check_command       => 'check_nrpe_1arg!check_neutron_metering_agent',
    service_description => 'Neutron Metering Agent',
  }

  icinga::service { 'check_neutron_server':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_neutron_server',
    check_command       => 'check_nrpe_1arg!check_neutron_server',
    service_description => 'Neutron Server',
  }

  icinga::service { 'check_neutron_server_netstat':
    use                 => 'dc_service_nrpe',
    hostgroup_name      => 'dc_hostgroup_neutron_server',
    check_command       => 'check_nrpe_1arg!check_neutron_server_netstat',
    service_description => 'Neutron Server Netstat',
  }

  icinga::service { 'check_neutron_api':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_neutron_server',
    check_command       => 'check_nrpe_1arg!check_neutron_server',
    service_description => 'Neutron API',
  }

  icinga::service { 'check_nova_compute':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_compute',
    check_command       => 'check_nrpe_1arg!check_nova_compute_proc',
    service_description => 'Nova Compute Process',
  }

  icinga::service { 'check_nova_compute_netstat':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_compute',
    check_command       => 'check_nrpe_1arg!check_nova_compute_netstat',
    service_description => 'Nova Compute Netstat',
  }

  icinga::service { 'check_nova_conductor':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_server',
    check_command       => 'check_nrpe_1arg!check_nova_conductor',
    service_description => 'Nova Conductor',
  }

  icinga::service { 'check_nova_scheduler':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_server',
    check_command       => 'check_nrpe_1arg!check_nova_scheduler',
    service_description => 'Nova Scheduler',
  }

  icinga::service { 'check_nova_scheduler_netstat':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_server',
    check_command       => 'check_nrpe_1arg!check_nova_scheduler_netstat',
    service_description => 'Nova Scheduler Netstat',
  }

  icinga::service { 'check_nova_consoleauth_netstat':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_server',
    check_command       => 'check_nrpe_1arg!check_nova_consoleauth_netstat',
    service_description => 'Nova Consoleauth Netstat',
  }

  icinga::service { 'check_nova_consoleauth':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_server',
    check_command       => 'check_nrpe_1arg!check_nova_consoleauth',
    service_description => 'Nova Consoleauth',
  }

  icinga::service { 'check_nova_cert':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_server',
    check_command       => 'check_nrpe_1arg!check_nova_cert',
    service_description => 'Nova Cert',
  }

  icinga::service { 'check_nova_ec2_api':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_server',
    check_command       => 'check_nova_ec2_api',
    service_description => 'Nova EC2 API',
  }

  icinga::service { 'check_nova_os_api':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_server',
    check_command       => 'check_nova_os_api',
    service_description => 'Nova Openstack API',
  }

  icinga::service { 'check_nova_os_metadata_api':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_server',
    check_command       => 'check_nova_os_metadata_api',
    service_description => 'Nova Openstack Metadata API',
  }

  icinga::service { 'check_rabbitmq_aliveness':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_rabbitmq',
    check_command       => 'check_rabbitmq_aliveness',
    service_description => 'RabbitMQ Aliveness',
  }

  icinga::service { 'check_rabbitmq_server':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_rabbitmq',
    check_command       => 'check_rabbitmq_server',
    service_description => 'RabbitMQ Server',
  }

  icinga::service { 'check_rabbitmq_objects':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_rabbitmq',
    check_command       => 'check_rabbitmq_objects',
    service_description => 'RabbitMQ Objects',
  }

  icinga::service { 'check_rabbitmq_partition':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_rabbitmq',
    check_command       => 'check_rabbitmq_partition',
    service_description => 'RabbitMQ Partitions',
  }

  icinga::service { 'check_rabbitmq_overview':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_rabbitmq',
    check_command       => 'check_rabbitmq_overview',
    service_description => 'RabbitMQ Overview',
  }

  icinga::service { 'check_rabbitmq_watermark':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_rabbitmq',
    check_command       => 'check_rabbitmq_watermark',
    service_description => 'RabbitMQ Watermark',
  }

  icinga::service { 'check_glance_http':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_glance',
    check_command       => 'check_glance_http',
    service_description => 'Glance API HTTP',
  }

  icinga::service { 'check_glance_registry_http':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_glance',
    check_command       => 'check_glance_registry_http',
    service_description => 'Glance Registry HTTP',
  }

  icinga::service { 'check_glance_api_proc':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_glance',
    check_command       => 'check_nrpe_1arg!check_glance_api_proc',
    service_description => 'Glance API Server Process',
  }

  icinga::service { 'check_glance_registry_proc':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_glance',
    check_command       => 'check_nrpe_1arg!check_glance_registry_proc',
    service_description => 'Glance Registry Server Process',
  }

  icinga::service { 'check_glance_registry_netstat':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_glance',
    check_command       => 'check_nrpe_1arg!check_glance_registry_netstat',
    service_description => 'Glance Registry Netstat',
  }

  icinga::service { 'check_dc_ldap':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_ldap',
    check_command       => 'check_dc_ldap',
    service_description => 'LDAP Server',
  }

  icinga::service { 'check_cinder_scheduler_proc':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_cinder',
    check_command       => 'check_nrpe_1arg!check_cinder_scheduler_proc',
    service_description => 'Cinder Scheduler Process',
  }

  icinga::service { 'check_cinder_api_proc':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_cinder',
    check_command       => 'check_nrpe_1arg!check_cinder_api_proc',
    service_description => 'Cinder API Server Process',
  }

  icinga::service { 'check_cinder_volume_proc':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_cinder',
    check_command       => 'check_nrpe_1arg!check_cinder_volume_proc',
    service_description => 'Cinder Volume Server Process',
  }

  icinga::service { 'check_cinder_volume_netstat':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_cinder',
    check_command       => 'check_nrpe_1arg!check_cinder_volume_netstat',
    service_description => 'Cinder Volume Server Netstat',
  }

  icinga::service { 'check_cinder_scheduler_netstat':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_cinder',
    check_command       => 'check_nrpe_1arg!check_cinder_scheduler_netstat',
    service_description => 'Cinder Scheduler Netstat',
  }

  icinga::service { 'check_cinder_api_http':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_cinder',
    check_command       => 'check_cinder_api_http',
    service_description => 'Cinder API HTTP',
  }

  icinga::service { 'check_hpasm':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_hpblade',
    check_command       => 'check_nrpe_1arg!check_hpasm',
    service_description => 'HP Blade Hardware Health',
  }

  icinga::service { 'check_lmsensors':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_lmsensors',
    check_command       => 'check_nrpe_1arg!check_sensors',
    service_description => 'Hardware Health',
  }

  icinga::service { 'check_nova_api_connect':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_osapiendpoint',
    check_command       => 'check_nova_api_connect',
    service_description => 'Nova API Connection',
  }

  icinga::service { 'check_glance_api_connect':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_osapiendpoint',
    check_command       => 'check_glance_api_connect',
    service_description => 'Glance API Connection',
  }

  icinga::service { 'check_nova_instance':
    use                 => 'dc_service_slowcheck',
    hostgroup_name      => 'dc_hostgroup_osapiendpoint',
    check_command       => 'check_nova_instance',
    service_description => 'Nova Instance Creation',
  }

  icinga::service { 'check_cinder_volume':
    use                 => 'dc_service_slowcheck',
    hostgroup_name      => 'dc_hostgroup_osapiendpoint',
    check_command       => 'check_cinder_volume',
    service_description => 'Cinder Volume Creation',
  }

  icinga::service { 'check_cinder_api_connect':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_osapiendpoint',
    check_command       => 'check_cinder_api_connect',
    service_description => 'Cinder API Connection',
  }

  icinga::service { 'check_ceph_health':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_ceph_mon',
    check_command       => 'check_nrpe_1arg!check_ceph_health',
    service_description => 'Ceph Cluster Health',
  }

  icinga::service { 'check_ceph_mon':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_ceph_mon',
    check_command       => 'check_nrpe_1arg!check_ceph_mon',
    service_description => 'Ceph Monitor Status',
  }

  icinga::service { 'check_ceph_osd':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_ceph_osd',
    check_command       => 'check_nrpe_1arg!check_ceph_osd',
    service_description => 'Ceph Object Storage Daemon Status',
  }

  icinga::service { 'check_ceph_rgw':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_ceph_rgw',
    check_command       => 'check_nrpe_1arg!check_ceph_rgw',
    service_description => 'Ceph Rados Gateway Status',
  }

  icinga::service { 'check_elasticsearch':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_elasticsearch',
    check_command       => 'check_es_updating',
    service_description => 'Elasticsearch',
  }

  icinga::service { 'check_log_courier':
    use                 => 'dc_service_secondary',
    hostgroup_name      => 'dc_hostgroup_generic',
    check_command       => 'check_nrpe_1arg!check_log_courier',
    service_description => 'Log Courier Status',
  }

  icinga::service { 'check_elasticsearch_cluster_health':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_elasticsearch',
    check_command       => 'check_es_cluster_health',
    service_description => 'Elasticsearch cluster health',
  }

  icinga::service { 'check_ceilometer_compute_proc':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_compute',
    check_command       => 'check_nrpe_1arg!check_ceilometer_compute_proc',
    service_description => 'Ceilometer Compute Agent',
  }

  icinga::service { 'check_ceilometer_notification_proc':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_server',
    check_command       => 'check_nrpe_1arg!check_ceilometer_notification_proc',
    service_description => 'Ceilometer Notification Agent',
  }

  icinga::service { 'check_ceilometer_central_proc':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_server',
    check_command       => 'check_nrpe_1arg!check_ceilometer_central_proc',
    service_description => 'Ceilometer Central Agent',
  }

  icinga::service { 'check_ceilometer_api_proc':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_server',
    check_command       => 'check_nrpe_1arg!check_ceilometer_api_proc',
    service_description => 'Ceilometer API Process',
  }

  icinga::service { 'check_ceilometer_collector_proc':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_server',
    check_command       => 'check_nrpe_1arg!check_ceilometer_collector_proc',
    service_description => 'Ceilometer Collector',
  }

  icinga::service { 'check_ceilometer_api_http':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_server',
    check_command       => 'check_ceilometer_api_http',
    service_description => 'Ceilometer API HTTP Connection',
  }

  icinga::service { 'check_ceilometer_api_connect':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_osapiendpoint',
    check_command       => 'check_ceilometer_api_connect',
    service_description => 'Ceilometer API',
  }

  icinga::service { 'check_lsyncd':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_lsyncd',
    check_command       => 'check_nrpe_1arg!check_lsyncd',
    service_description => 'Lsyncd Sync Daemon',
  }

  icinga::service { 'check_mongo_connect':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_mongodb',
    check_command       => 'check_mongodb_dc!connect!27017!2!4',
    service_description => 'MongoDB Connect Check',
  }

  icinga::service { 'check_mongo_free_connections':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_mongodb',
    check_command       => 'check_mongodb_dc!connections!27017!70!80',
    service_description => 'MongoDB Free Connections',
  }

  icinga::service { 'check_mongo_replication_lag':
    use                 => 'dc_service_slowcheck',
    hostgroup_name      => 'dc_hostgroup_mongodb',
    check_command       => 'check_mongodb_alias_dc!replication_lag!27017!15!30',
    service_description => 'MongoDB Replication Lag',
  }

  icinga::service { 'check_mongo_replication_lag_percent':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_mongodb',
    check_command       => 'check_mongodb_admin_dc!replication_lag_percent!27017!50!75',
    service_description => 'MongoDB Replication Lag Percentage',
  }

  icinga::service { 'check_mongo_memory':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_mongodb',
    check_command       => 'check_mongodb_dc!memory!27017!20!28',
    service_description => 'MongoDB Memory Usage',
  }

  icinga::service { 'check_mongo_lock_time_percentage':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_mongodb',
    check_command       => 'check_mongodb_dc!lock!27017!5!10',
    service_description => 'MongoDB Lock Percentage',
  }

  icinga::service { 'check_mongo_flush_average':
    use                 => 'dc_service_secondary',
    hostgroup_name      => 'dc_hostgroup_mongodb',
    check_command       => 'check_mongodb_dc!flushing!27017!5000!15000',
    service_description => 'MongoDB Flush Average',
  }

  icinga::service { 'check_mongo_last_flush':
    use                 => 'dc_service_secondary',
    hostgroup_name      => 'dc_hostgroup_mongodb',
    check_command       => 'check_mongodb_dc!last_flush_time!27017!5000!15000',
    service_description => 'MongoDB Last Flush Time',
  }

  icinga::service { 'check_mongo_replica_state':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_mongodb',
    check_command       => 'check_mongodb_dc!replset_state!27017!0!0',
    service_description => 'MongoDB Replica State',
  }

  icinga::service { 'check_mongo_index_miss':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_mongodb',
    check_command       => 'check_mongodb_dc!index_miss_ratio!27017!.005!.01',
    service_description => 'MongoDB Index Miss Ratio',
  }

  icinga::service { 'check_mongo_primary_connection':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_mongodb',
    check_command       => 'check_mongodb_dc!connect_primary!27017!2!4',
    service_description => 'MongoDB Primary Connection',
  }

  icinga::service { 'check_postgres_replication':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_postgres',
    check_command       => 'check_nrpe_1arg!check_postgres_replication',
    max_check_attempts  => '10',
    service_description => 'Postgres Streaming Replication',
  }

  icinga::service { 'check_compute_hw':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_compute',
    check_command       => 'check_nrpe_1arg!check_compute_hw',
    service_description => 'Compute Node Hardware Config',
  }

  icinga::service { 'check_cephosd_hw':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_ceph_osd',
    check_command       => 'check_nrpe_1arg!check_cephosd_hw',
    service_description => 'OSD Node Hardware Config',
  }

  icinga::service { 'check_net_interfaces':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_generic',
    check_command       => 'check_nrpe_1arg!check_net_interfaces',
    service_description => 'Interface Checks',
  }

  icinga::service { 'check_supermicro_psu_ipmi':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_supermicro',
    check_command       => 'check_nrpe_1arg!check_supermicro_psu_ipmi',
    service_description => 'Supermicro PSU Check',
  }

  icinga::service { 'check_bmc':
    use                 => 'dc_service_secondary',
    hostgroup_name      => 'dc_hostgroup_bmc',
    check_command       => 'check_bmc',
    service_description => 'BMC Network Check',
  }

  icinga::service { 'check_bmc_nrpe':
    use                 => 'dc_service_secondary',
    hostgroup_name      => 'dc_hostgroup_bmc',
    check_command       => 'check_nrpe_1arg!check_bmc',
    service_description => 'IPMI NRPE Check',
  }

  icinga::service { 'check_foreman_interfaces':
    use                 => 'dc_service_secondary',
    hostgroup_name      => 'dc_hostgroup_generic',
    check_command       => 'check_nrpe_1arg!check_foreman_interfaces',
    service_description => 'Foreman Interfaces Check',
  }

  icinga::service { 'check_journal_disk_latency':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_ceph_osd',
    check_command       => 'check_nrpe_1arg!check_journal_disk_latency',
    service_description => 'Journal Disk Latency',
  }

  icinga::service { 'check_memcached':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_memcached',
    check_command       => 'check_memcached_dc',
    service_description => 'memcached Availability Check'
  }

  icinga::service { 'check_disk_stats':
    use                 => 'dc_service_nrpe',
    hostgroup_name      => 'dc_hostgroup_generic',
    check_command       => 'check_nrpe_1arg!check_disk_stats',
    service_description => 'Disk Stats Check',
  }

  icinga::service { 'check_ovswitch_proc':
    use                 => 'dc_service_nrpe',
    hostgroup_name      => 'dc_hostgroup_neutron_node, dc_hostgroup_nova_compute',
    check_command       => 'check_nrpe_1arg!check_ovswitch_proc',
    service_description => 'OpenvSwitch Process Check',
  }

  icinga::service { 'check_neutron_vswitch_agent':
    use                 => 'dc_service_nrpe',
    hostgroup_name      => 'dc_hostgroup_neutron_node, dc_hostgroup_nova_compute',
    check_command       => 'check_nrpe_1arg!check_neutron_vswitch_agent',
    service_description => 'Neutron OpenvSwitch Agent Check',
  }

  icinga::service { 'check_ovswitch_server_proc':
    use                 => 'dc_service_nrpe',
    hostgroup_name      => 'dc_hostgroup_neutron_node, dc_hostgroup_nova_compute',
    check_command       => 'check_nrpe_1arg!check_ovswitch_server_proc',
    service_description => 'OpenvSwitch DB Server Check',
  }

  icinga::service { 'check_neutron_routers':
    use                 => 'dc_service_nrpe',
    hostgroup_name      => 'dc_hostgroup_neutron_node',
    check_command       => 'check_nrpe_1arg!check_neutron_routers',
    service_description => 'Neutron Duplicate Routers',
  }

  icinga::service { 'check_haproxy':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_haproxy',
    check_command       => 'check_haproxy_dc',
    service_description => 'HAProxy Status',
  }

}

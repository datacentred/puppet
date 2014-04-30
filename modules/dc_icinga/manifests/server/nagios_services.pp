class dc_icinga::server::nagios_services {

  # Define services
  ######################################################################
  # These are the generic services that are locally monitored
  # via NRPE therefore must be defined in /etc/nagios/nrpe.cfg
  ######################################################################

  nagios_service { 'check_all_disks':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_generic',
    check_command       => 'check_nrpe_1arg!check_all_disks',
    service_description => 'Disk Space',
  }

  nagios_service { 'check_load':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_generic',
    check_command       => 'check_nrpe_1arg!check_load',
    service_description => 'Load Average',
  }

  nagios_service { 'check_users':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_generic',
    check_command       => 'check_nrpe_1arg!check_users',
    service_description => 'Users',
  }

  nagios_service { 'check_procs':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_generic',
    check_command       => 'check_nrpe_1arg!check_total_procs',
    service_description => 'Processes',
  }

  # Logstash

  nagios_service { 'check_logstashes':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_logstashes',
    check_command       => 'check_nrpe_1arg!check_logstashes',
    service_description => 'Logstash ES',
  }

  nagios_service { 'check_keystone':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_keystone',
    check_command       => 'check_keystone_dc',
    service_description => 'Keystone',
  }

  nagios_service { 'check_ping':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_generic',
    check_command       => 'check_ping!100.0,20%!500.0,60%',
    service_description => 'Ping',
  }

  nagios_service { 'check_ssh':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_generic',
    check_command       => 'check_ssh',
    service_description => 'SSH',
  }

  nagios_service { 'check_http':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_http',
    check_command       => 'check_http',
    service_description => 'HTTP',
  }

  nagios_service { 'check_https':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_https',
    check_command       => 'check_https',
    service_description => 'HTTPS',
  }

  nagios_service { 'check_pgsql':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_postgres',
    check_command       => 'check_pgsql_dc!nagiostest!nagios!nagios',
    service_description => 'PostgreSQL',
  }

  nagios_service { 'check_dhcp':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_dhcp',
    check_command       => 'check_dhcp_interface!bond0',
    service_description => 'DHCP',
  }

  nagios_service { 'check_dns':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_dns',
    check_command       => 'check_dns',
    service_description => 'DNS',
  }

  nagios_service { 'check_ntp':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_ntp',
    check_command       => 'check_ntp_dc',
    service_description => 'NTP',
  }

  nagios_service { 'check_puppetdb':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_puppetdb',
    check_command       => 'check_nrpe_1arg!check_puppetdb',
    service_description => 'Puppet DB REST API',
  }

  nagios_service { 'check_foreman_proxy':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_foreman_proxy',
    check_command       => 'check_foreman_proxy_dc',
    service_description => 'Foreman Proxy REST API',
  }

  nagios_service { 'check_tftp':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_tftp',
    check_command       => 'check_tftp_dc',
    service_description => 'TFTP',
  }

  nagios_service { 'check_mysql':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_mysql',
    check_command       => 'check_mysql_dc',
    service_description => 'MySQL',
  }

  nagios_service { 'check_nfs':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nfs',
    check_command       => 'check_nfs_dc',
    service_description => 'NFS',
  }

  nagios_service { 'check_foreman':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_foreman',
    check_command       => 'check_foreman_dc',
    service_description => 'Foreman',
  }

  nagios_service { 'check_smtp':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_smtp',
    check_command       => 'check_smtp',
    service_description => 'SMTP',
  }

  nagios_service { 'check_postfix_queue':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_postfix',
    check_command       => 'check_nrpe_1arg!check_mailq_postfix',
    service_description => 'Postfix Mail Queue',
  }

  nagios_service { 'check_nova_compute':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_compute',
    check_command       => 'check_nrpe_1arg!check_nova_compute_proc',
    service_description => 'Nova Compute Process',
  }

  nagios_service { 'check_neutron_vswitch_agent':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_compute, dc_hostgroup_neutron_node, dc_hostgroup_neutron_server',
    check_command       => 'check_nrpe_1arg!check_neutron_vswitch_agent',
    service_description => 'Neutron Agent',
  }

  nagios_service { 'check_ovswitch_proc':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_compute, dc_hostgroup_neutron_node, dc_hostgroup_neutron_server',
    check_command       => 'check_nrpe_1arg!check_ovswitch_proc',
    service_description => 'Open vSwitch',
  }

  nagios_service { 'check_ovswitch_server_proc':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_compute, dc_hostgroup_neutron_node, dc_hostgroup_neutron_server',
    check_command       => 'check_nrpe_1arg!check_ovswitch_server_proc',
    service_description => 'Open vSwitch DB Server',
  }

  nagios_service { 'check_neutron_dhcp_agent':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_neutron_node',
    check_command       => 'check_nrpe_1arg!check_neutron_dhcp_agent',
    service_description => 'Neutron DHCP Agent',
  }

  nagios_service { 'check_neutron_l3_agent':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_neutron_node',
    check_command       => 'check_nrpe_1arg!check_neutron_l3_agent',
    service_description => 'Neutron L3 Agent',
  }

  nagios_service { 'check_neutron_metadata_agent':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_neutron_node',
    check_command       => 'check_nrpe_1arg!check_neutron_metadata_agent',
    service_description => 'Neutron Metadata Agent',
  }

  nagios_service { 'check_neutron_vpn_agent':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_neutron_node',
    check_command       => 'check_nrpe_1arg!check_neutron_vpn_agent',
    service_description => 'Neutron VPN Agent',
  }

  nagios_service { 'check_neutron_lbaas_agent':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_neutron_node',
    check_command       => 'check_nrpe_1arg!check_neutron_lbaas_agent',
    service_description => 'Neutron LBAAS Agent',
  }

  nagios_service { 'check_neutron_metering_agent':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_neutron_node',
    check_command       => 'check_nrpe_1arg!check_neutron_metering_agent',
    service_description => 'Neutron Metering Agent',
  }

  nagios_service { 'check_neutron_server':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_neutron_server',
    check_command       => 'check_nrpe_1arg!check_neutron_server',
    service_description => 'Neutron Server',
  }

  nagios_service { 'check_neutron_api':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_neutron_server',
    check_command       => 'check_nrpe_1arg!check_neutron_server',
    service_description => 'Neutron API',
  }

  nagios_service { 'check_nova_conductor':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_server',
    check_command       => 'check_nrpe_1arg!check_nova_conductor',
    service_description => 'Nova Conductor',
  }

  nagios_service { 'check_nova_scheduler':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_server',
    check_command       => 'check_nrpe_1arg!check_nova_scheduler',
    service_description => 'Nova Scheduler',
  }

  nagios_service { 'check_nova_consoleauth':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_server',
    check_command       => 'check_nrpe_1arg!check_nova_consoleauth',
    service_description => 'Nova Consoleauth',
  }

  nagios_service { 'check_nova_cert':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_server',
    check_command       => 'check_nrpe_1arg!check_nova_cert',
    service_description => 'Nova Cert',
  }

  nagios_service { 'check_nova_ec2_api':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_server',
    check_command       => 'check_nova_ec2_api',
    service_description => 'Nova EC2 API',
  }

  nagios_service { 'check_nova_os_api':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_server',
    check_command       => 'check_nova_os_api',
    service_description => 'Nova Openstack API',
  }

  nagios_service { 'check_nova_os_metadata_api':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_nova_server',
    check_command       => 'check_nova_os_metadata_api',
    service_description => 'Nova Openstack Metadata API',
  }

  nagios_service { 'check_rabbitmq_aliveness':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_rabbitmq',
    check_command       => 'check_rabbitmq_aliveness',
    service_description => 'RabbitMQ Aliveness',
  }

  nagios_service { 'check_rabbitmq_server':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_rabbitmq',
    check_command       => 'check_rabbitmq_server',
    service_description => 'RabbitMQ Server',
  }

  nagios_service { 'check_rabbitmq_objects':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_rabbitmq',
    check_command       => 'check_rabbitmq_objects',
    service_description => 'RabbitMQ Objects',
  }

  nagios_service { 'check_rabbitmq_partition':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_rabbitmq',
    check_command       => 'check_rabbitmq_partition',
    service_description => 'RabbitMQ Partitions',
  }

  nagios_service { 'check_rabbitmq_overview':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_rabbitmq',
    check_command       => 'check_rabbitmq_overview',
    service_description => 'RabbitMQ Overview',
  }

  nagios_service { 'check_rabbitmq_watermark':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_rabbitmq',
    check_command       => 'check_rabbitmq_watermark',
    service_description => 'RabbitMQ Watermark',
  }
}

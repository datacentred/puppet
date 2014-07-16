# Class:
#
# Configures the icinga environment for use in our production network.
# Primarily handles the static nagios configuration content and
# instantiates clients from stored configs on puppetdb
#
# Parameters:
#
# $cfg_path
#     Specifies where the nagios configuration files should be generated
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_icinga::server::config {

  $keystone_host = get_exported_var('', 'keystone_host', ['localhost'])
  $keystone_icinga_password = hiera(keystone_icinga_password)
  $keystone_icinga_user = hiera(keystone_icinga_user)
  $keystone_icinga_tenant = hiera(keystone_icinga_tenant)
  $keystone_port = hiera(keystone_port)
  $nova_osapi_port = hiera(nova_osapi_port)
  $glance_api_port = hiera(glance_api_port)
  $foreman_icinga_pw = hiera(foreman_icinga_pw)
  $rabbitmq_monuser = hiera(rabbitmq_monuser)
  $rabbitmq_monuser_password = hiera(rabbitmq_monuser_password)
  $mariadb_icinga_pw = hiera(mariadb_icinga_pw)
  $ldap_server_suffix = hiera(ldap::server::suffix)
  $ldap_server = "ldap.${::domain}"

  # Add custom plugins
  include dc_icinga::server::custom_plugins

  # This particular plugin needs to be executed as
  # root, so setuid.  It should be part of the generic
  # class bu alas you get a circular dependency with
  # the directory declaration in
  # dc_icinga::server::custom_plugins
  file { '/usr/lib/nagios/plugins/check_dhcp':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '4755',
  }

  # Icinga web configuration for LDAP users
  package { 'php-net-ldap':
    ensure => installed,
  }

  file { '/usr/share/icinga-web/app/modules/AppKit/config/auth.xml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dc_icinga/auth.xml.erb'),
    notify  => Exec['clearcache.sh'],
  }

  exec { 'clearcache.sh':
    command     => '/usr/lib/icinga-web/bin/clearcache.sh',
    refreshonly => true,
  }

  # Fix permissions on command file directory

  file { '/var/lib/icinga/rw':
    ensure => directory,
    owner  => 'nagios',
    group  => 'www-data',
    mode   => '2710',
    notify => Service['icinga'],
  }

  ######################################################################
  # Service periods
  ######################################################################

  icinga::timeperiod { 'dc_timeperiod_24x7':
    description => '24 Hours A Day, 7 Days A Week',
    sunday      => '00:00-24:00',
    monday      => '00:00-24:00',
    tuesday     => '00:00-24:00',
    wednesday   => '00:00-24:00',
    thursday    => '00:00-24:00',
    friday      => '00:00-24:00',
    saturday    => '00:00-24:00',
  }

  ######################################################################
  # Contact groups
  ######################################################################

  icinga::contactgroup { 'dc_admins':
    description => 'Icinga Administrators',
  }

  ######################################################################
  # Contacts
  ######################################################################

  icinga::contact { 'sysadmin':
    description                   => 'System Administrators',
    email                         => hiera(sal01_internal_sysmail_address),
    contactgroups                 => 'dc_admins',
    service_notification_period   => 'dc_timeperiod_24x7',
    host_notification_period      => 'dc_timeperiod_24x7',
    service_notification_options  => 'w,u,c,r',
    host_notification_options     => 'd,r',
    service_notification_commands => 'notify-service-by-email',
    host_notification_commands    => 'notify-host-by-email',
  }

  ######################################################################
  # Host templates
  ######################################################################

  icinga::host { 'dc_host_generic':
    notifications_enabled        => '1',
    event_handler_enabled        => '1',
    flap_detection_enabled       => '1',
    failure_prediction_enabled   => '1',
    process_perf_data            => '1',
    retain_status_information    => '1',
    retain_nonstatus_information => '1',
    check_command                => 'check_ping!100.0,20%!500.0,60%',
    max_check_attempts           => '2',
    notification_interval        => '0',
    notification_period          => 'dc_timeperiod_24x7',
    notification_options         => 'd,u,r',
    contact_groups               => 'dc_admins',
    register                     => '0',
  }

  ######################################################################
  # Service templates
  ######################################################################

  icinga::service { 'dc_service_generic':
    active_checks_enabled        => '1',
    passive_checks_enabled       => '1',
    parallelize_check            => '1',
    obsess_over_service          => '1',
    check_freshness              => '0',
    notifications_enabled        => '1',
    event_handler_enabled        => '1',
    flap_detection_enabled       => '1',
    failure_prediction_enabled   => '1',
    process_perf_data            => '1',
    retain_status_information    => '1',
    retain_nonstatus_information => '1',
    notification_interval        => '0',
    is_volatile                  => '0',
    check_period                 => 'dc_timeperiod_24x7',
    normal_check_interval        => '5',
    retry_check_interval         => '1',
    max_check_attempts           => '4',
    notification_period          => 'dc_timeperiod_24x7',
    notification_options         => 'w,u,c,r',
    contact_groups               => 'dc_admins',
    register                     => '0',
  }

  ######################################################################
  # Host groups
  ######################################################################

  icinga::hostgroup { 'dc_hostgroup_generic':
    description => 'All Hosts',
    members     => '*',
  }

  icinga::hostgroup { 'dc_hostgroup_http':
    description => 'HTTP Servers',
  }

  icinga::hostgroup { 'dc_hostgroup_https':
    description => 'HTTPS Servers',
  }

  icinga::hostgroup { 'dc_hostgroup_puppetmaster':
    description => 'Puppet Masters',
  }

  icinga::hostgroup { 'dc_hostgroup_postgres':
    description => 'PostgreSQL Servers',
  }

  icinga::hostgroup { 'dc_hostgroup_dhcp':
    description => 'DHCP Servers',
  }

  icinga::hostgroup { 'dc_hostgroup_tftp':
    description => 'TFTP Servers',
  }

  icinga::hostgroup { 'dc_hostgroup_dns':
    description => 'DNS Servers',
  }

  icinga::hostgroup { 'dc_hostgroup_ntp':
    description => 'NTP Servers',
  }

  icinga::hostgroup { 'dc_hostgroup_puppetdb':
    description => 'Puppet DB Servers',
  }

  icinga::hostgroup { 'dc_hostgroup_foreman_proxy':
    description => 'Foreman Proxies',
  }

  icinga::hostgroup { 'dc_hostgroup_mysql':
    description => 'MySQL Servers',
  }

  icinga::hostgroup { 'dc_hostgroup_logstashes':
    description => 'Logstash ElasticSearch Servers',
  }

  icinga::hostgroup { 'dc_hostgroup_keystone':
    description => 'Openstack Keystone Servers',
  }

  icinga::hostgroup { 'dc_hostgroup_nfs':
    description => 'NFS Servers',
  }

  icinga::hostgroup { 'dc_hostgroup_foreman':
    description => 'Foreman Servers',
  }

  icinga::hostgroup { 'dc_hostgroup_smtp':
    description => 'SMTP Servers',
  }

  icinga::hostgroup { 'dc_hostgroup_postfix':
    description => 'Postfix Servers',
  }

  icinga::hostgroup { 'dc_hostgroup_nova_compute':
    description => 'Openstack Compute Nodes',
  }

  icinga::hostgroup { 'dc_hostgroup_neutron_node':
    description => 'Openstack Neutron Nodes',
  }

  icinga::hostgroup { 'dc_hostgroup_neutron_server':
    description => 'Openstack Neutron Servers',
  }

  icinga::hostgroup { 'dc_hostgroup_nova_server':
    description => 'Openstack Nova Servers',
  }

  icinga::hostgroup { 'dc_hostgroup_rabbitmq':
    description => 'RabbitMQ Nodes',
  }

  icinga::hostgroup { 'dc_hostgroup_glance':
    description => 'Glance Servers',
  }

  icinga::hostgroup { 'dc_hostgroup_ldap':
    description => 'LDAP Servers',
  }

  icinga::hostgroup { 'dc_hostgroup_cinder':
    description => 'Cinder Servers',
  }

  icinga::hostgroup { 'dc_hostgroup_hpblade':
    description => 'HP Blades',
  }

  icinga::hostgroup { 'dc_hostgroup_lmsensors':
    description => 'Hardware Sensors',
  }

  icinga::hostgroup { 'dc_hostgroup_osapiendpoint':
    description => 'Openstack API Endpoints',
  }
  ######################################################################
  # Commands
  ######################################################################
  # Define custom commands not provided by nagios-plugins
  ######################################################################

  icinga::command { 'notify-host-by-email':
    command_line => '/usr/bin/printf "%b" "***** Icinga *****\n\nNotification Type: $NOTIFICATIONTYPE$\nHost: $HOSTNAME$\nState: $HOSTSTATE$\nAddress: $HOSTADDRESS$\nInfo: $HOSTOUTPUT$\n\nDate/Time: $LONGDATETIME$\n" | /usr/bin/mail -s "** $NOTIFICATIONTYPE$ Host Alert: $HOSTNAME$ is $HOSTSTATE$ **" $CONTACTEMAIL$',
  }

  icinga::command { 'notify-service-by-email':
    command_line => '/usr/bin/printf "%b" "***** Icinga *****\n\nNotification Type: $NOTIFICATIONTYPE$\n\nService: $SERVICEDESC$\nHost: $HOSTALIAS$\nAddress: $HOSTADDRESS$\nState: $SERVICESTATE$\n\nDate/Time: $LONGDATETIME$\n\nAdditional Info:\n\n$SERVICEOUTPUT$\n" | /usr/bin/mail -s "** $NOTIFICATIONTYPE$ Service Alert: $HOSTALIAS$/$SERVICEDESC$ is $SERVICESTATE$ **" $CONTACTEMAIL$',
  }

  icinga::command { 'check_pgsql_dc':
    command_line => '/usr/lib/nagios/plugins/check_pgsql -H $HOSTADDRESS$ -d $ARG1$ -l $ARG2$ -p $ARG3$',
  }

  icinga::command { 'check_ntp_dc':
    command_line => '/usr/lib/nagios/plugins/check_ntp_time -H $HOSTADDRESS$',
  }

  icinga::command { 'check_foreman_proxy_dc':
    command_line => '/usr/lib/nagios/plugins/check_http -H $HOSTADDRESS$ --ssl -p 8443 -u /version',
  }

  icinga::command { 'check_tftp_dc':
    command_line => '/usr/lib/nagios/plugins/check_tftp -H $HOSTADDRESS$ -p nagios_test_file',
  }

  icinga::command { 'check_mysql_dc':
    command_line => "/usr/lib/nagios/plugins/check_mysql -H \$HOSTADDRESS$ -u icinga -p ${mariadb_icinga_pw}",
  }

  icinga::command { 'check_nfs_dc':
    command_line => '/usr/lib/nagios/plugins/check_rpc -H $HOSTADDRESS$ -C nfs -c2,3,4',
  }

  icinga::command { 'check_keystone_dc':
    command_line => "/usr/lib/nagios/plugins/check_keystone --auth_url http://\$HOSTADDRESS\$:5000/v2.0 --username icinga --password ${keystone_icinga_password} --tenant icinga"
  }

  icinga::command { 'check_nova_ec2_api':
    command_line => "/usr/lib/nagios/plugins/check_http -u /services/Cloud/ -e 400 -H \$HOSTADDRESS$ -p 8773"
  }

  icinga::command { 'check_nova_os_api':
    command_line => "/usr/lib/nagios/plugins/check_http -H \$HOSTADDRESS$ -p 8774"
  }

  icinga::command { 'check_nova_os_metadata_api':
    command_line => "/usr/lib/nagios/plugins/check_http -H \$HOSTADDRESS$ -p 8775"
  }

  icinga::command { 'check_neutron_api':
    command_line => "/usr/lib/nagios/plugins/check_http -H \$HOSTADDRESS$ -p 9696"
  }

  icinga::command { 'check_rabbitmq_aliveness':
    command_line => "/usr/lib/nagios/plugins/check_rabbitmq_aliveness -u ${rabbitmq_monuser} -p ${rabbitmq_monuser_password} -H \$HOSTADDRESS$ --port=15672"
  }

  icinga::command { 'check_rabbitmq_server':
    command_line => "/usr/lib/nagios/plugins/check_rabbitmq_server -u ${rabbitmq_monuser} -p ${rabbitmq_monuser_password} -H \$HOSTNAME$ --port=15672"
  }

  icinga::command { 'check_rabbitmq_overview':
    command_line => "/usr/lib/nagios/plugins/check_rabbitmq_overview -u ${rabbitmq_monuser} -p ${rabbitmq_monuser_password} -H \$HOSTADDRESS$ --port=15672"
  }

  icinga::command { 'check_rabbitmq_watermark':
    command_line => "/usr/lib/nagios/plugins/check_rabbitmq_watermark -u ${rabbitmq_monuser} -p ${rabbitmq_monuser_password} -H \$HOSTNAME$ --port=15672"
  }

  icinga::command { 'check_rabbitmq_partition':
    command_line => "/usr/lib/nagios/plugins/check_rabbitmq_partition -u ${rabbitmq_monuser} -p ${rabbitmq_monuser_password} -H \$HOSTNAME$ --port=15672"
  }

  icinga::command { 'check_rabbitmq_shovels':
    command_line => "/usr/lib/nagios/plugins/check_rabbitmq_shovels -u ${rabbitmq_monuser} -p ${rabbitmq_monuser_password} -H \$HOSTADDRESS$ --port=15672"
  }

  icinga::command { 'check_rabbitmq_queue':
    command_line => "/usr/lib/nagios/plugins/check_rabbitmq_queue -u ${rabbitmq_monuser} -p ${rabbitmq_monuser_password} -H \$HOSTADDRESS$ --port=15672"
  }

  icinga::command { 'check_rabbitmq_objects':
    command_line => "/usr/lib/nagios/plugins/check_rabbitmq_objects -u ${rabbitmq_monuser} -p ${rabbitmq_monuser_password} -H \$HOSTADDRESS$ --port=15672"
  }

  icinga::command { 'check_glance_http':
    command_line => "/usr/lib/nagios/plugins/check_http -H \$HOSTADDRESS$ -p 9292"
  }

  icinga::command { 'check_glance_registry_http':
    command_line => "/usr/lib/nagios/plugins/check_http -e 401 -H \$HOSTADDRESS$ -p 9191"
  }

  icinga::command { 'check_dc_ldap':
    command_line => "/usr/lib/nagios/plugins/check_ldap -H \$HOSTADDRESS$ -b ${ldap_server_suffix}"
  }

  icinga::command { 'check_cinder_api_http':
    command_line => "/usr/lib/nagios/plugins/check_http -H \$HOSTADDRESS$ -p 8776"
  }

  icinga::command { 'check_glance_api_http':
    command_line => "/usr/lib/nagios/plugins/check_http -H \$HOSTADDRESS$ -p 8776"
  }

  icinga::command { 'check_nova_instance':
    command_line => "/usr/lib/nagios/plugins/check_nova-instance.sh -H http://\$HOSTADDRESS\$:${keystone_port}/v2.0 -E http://\$HOSTADDRESS\$:${nova_osapi_port}/v2 -T ${keystone_icinga_tenant} -U ${keystone_icinga_user} -P ${keystone_icinga_password} -N icinga -I CirrOS\\ 0.3.2\\ x86_64 -F m1.tiny -r"
  }

  icinga::command { 'check_nova_api_connect':
    command_line => "/usr/lib/nagios/plugins/check_nova-api.sh -H http://\$HOSTADDRESS\$:${keystone_port}/v2.0 -E http://\$HOSTADDRESS\$:${nova_osapi_port}/v2 -T ${keystone_icinga_tenant} -U ${keystone_icinga_user} -P ${keystone_icinga_password}"
  }

  icinga::command { 'check_glance_api_connect':
    command_line => "/usr/lib/nagios/plugins/check_glance-api.sh -H http://\$HOSTADDRESS\$:${keystone_port}/v2.0 -E http://\$HOSTADDRESS\$:${glance_api_port}/v2 -T ${keystone_icinga_tenant} -U ${keystone_icinga_user} -P ${keystone_icinga_password}"
  }
  ######################################################################

  include dc_icinga::server::nagios_services

}


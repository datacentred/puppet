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

  $ldap_suffix = hiera(ldap_suffix)
  $ldap_host = hiera(ldap_host)

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
  # www-data user needs to read the puppet certs for LDAPS
  user { 'www-data':
    groups => 'puppet',
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

  # Change defaults for nrpe checks
  # Increase timeout and send unknown on socket timeout
  file { '/etc/nagios-plugins/config/check_nrpe.cfg':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/dc_icinga/check_nrpe.cfg',
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
    description => 'On Call Pagerduty',
  }

  icinga::contactgroup { 'dc_admins_email':
    description => 'Email Notification Only',
  }
  ######################################################################
  # Contacts
  ######################################################################

  icinga::contact { 'sysadmin':
    description                   => 'System Administrators',
    email                         => hiera(internal_sysmail_address),
    contactgroups                 => 'dc_admins_email',
    service_notification_period   => 'dc_timeperiod_24x7',
    host_notification_period      => 'dc_timeperiod_24x7',
    service_notification_options  => 'w,u,c,r',
    host_notification_options     => 'd,r',
    service_notification_commands => 'notify-service-by-email',
    host_notification_commands    => 'notify-host-by-email',
  }

  icinga::contact { 'pagerduty':
    description                   => 'PagerDuty Pseudo-Contact',
    pager                         => $dc_icinga::server::pagerduty_api_key,
    contactgroups                 => 'dc_admins',
    service_notification_period   => 'dc_timeperiod_24x7',
    host_notification_period      => 'dc_timeperiod_24x7',
    service_notification_options  => 'w,u,c,r',
    host_notification_options     => 'd,r',
    service_notification_commands => 'notify-service-by-pagerduty',
    host_notification_commands    => 'notify-host-by-pagerduty',
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
    contact_groups               => 'dc_admins,dc_admins_email',
    register                     => '0',
  }

  icinga::host { 'dc_host_device':
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
    contact_groups               => 'dc_admins,dc_admins_email',
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
    contact_groups               => 'dc_admins,dc_admins_email',
    register                     => '0',
  }

  icinga::service { 'dc_service_secondary':
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
    max_check_attempts           => '10',
    notification_period          => 'dc_timeperiod_24x7',
    notification_options         => 'w,u,c,r',
    contact_groups               => 'dc_admins_email',
    register                     => '0',
  }

  icinga::service { 'dc_service_slowcheck':
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
    normal_check_interval        => '20',
    retry_check_interval         => '10',
    max_check_attempts           => '10',
    notification_period          => 'dc_timeperiod_24x7',
    notification_options         => 'w,u,c,r',
    contact_groups               => 'dc_admins, dc_admins_email',
    register                     => '0',
  }

  icinga::service { 'dc_service_nrpe':
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
    max_check_attempts           => '10',
    notification_period          => 'dc_timeperiod_24x7',
    notification_options         => 'w,c,r',
    contact_groups               => 'dc_admins,dc_admins_email',
    register                     => '0',
  }
  ######################################################################
  # Host groups
  ######################################################################

  icinga::hostgroup { 'dc_hostgroup_generic':
    description => 'All Server Hosts',
  }

  icinga::hostgroup { 'dc_hostgroup_x86':
    description => 'All x86 Server Hosts',
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

  icinga::hostgroup { 'dc_hostgroup_apcpdu':
    description => 'APC PDU',
  }

  icinga::hostgroup { 'dc_hostgroup_ceph_mon':
    description => 'Ceph Monitor',
  }

  icinga::hostgroup { 'dc_hostgroup_ceph_osd':
    description => 'Ceph Object Storage Daemon',
  }

  icinga::hostgroup { 'dc_hostgroup_ceph_rgw':
    description => 'Ceph Rados Gateway',
  }

  icinga::hostgroup { 'dc_hostgroup_haproxy':
    description => 'HA Proxy Node',
  }

  icinga::hostgroup { 'dc_hostgroup_elasticsearch':
    description => 'Elasticsearch Node',
  }

  icinga::hostgroup { 'dc_hostgroup_lsyncd':
    description => 'Lsyncd Sync Master',
  }

  icinga::hostgroup { 'dc_hostgroup_mongodb':
    description => 'MongoDB Nodes',
  }

  icinga::hostgroup { 'dc_hostgroup_supermicro':
    description => 'Supermicro X8 Class Hardware',
  }

  icinga::hostgroup { 'dc_hostgroup_supermicro_x9':
    description => 'SuperMicro X9 Class Hardware',
  }

  icinga::hostgroup { 'dc_hostgroup_bmc':
    description => 'BMC Capable Nodes',
  }

  icinga::hostgroup { 'dc_hostgroup_memcached':
    description => 'memcached Node',
  }

  icinga::hostgroup { 'dc_hostgroup_beaver':
    description => 'Beaver',
  }

  include dc_icinga::server::nagios_services
  include dc_icinga::server::nagios_commands

}


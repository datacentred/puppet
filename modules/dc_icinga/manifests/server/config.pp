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
class dc_icinga::server::config (
  $password = hiera(icinga_gui_password),
) {

  include dc_icinga::params
  $cfg_path = $::dc_icinga::params::cfg_path
  $obj_path = $::dc_icinga::params::obj_path

  $dc_timeperiods_file   = "${obj_path}/dc_timeperiods.cfg"
  $dc_contacts_file      = "${obj_path}/dc_contacts.cfg"
  $dc_hostgroups_file    = "${obj_path}/dc_hostgroups.cfg"
  $dc_servicegroups_file = "${obj_path}/dc_servicegroups.cfg"
  $dc_hosts_file         = "${obj_path}/dc_hosts.cfg"
  $dc_services_file      = "${obj_path}/dc_services.cfg"
  $dc_commands_file      = "${cfg_path}/commands.cfg"

  $keystone_host = get_exported_var('', 'keystone_host', ['localhost'])
  $keystone_icinga_password = hiera(keystone_icinga_password)
  $foreman_icinga_pw = hiera(foreman_icinga_pw)
  $rabbitmq_monuser = hiera(rabbitmq_monuser)
  $rabbitmq_monuser_password = hiera(rabbitmq_monuser_password)
  $mariadb_icinga_pw = hiera(mariadb_icinga_pw)
  $ldap_server_suffix = hiera(ldap::server::suffix)

  # When doing a non interactive install the password isn't generated
  # so do that for us first time around
  exec { 'icinga_cgi_passwd':
    command => "/usr/bin/htpasswd -c -b htpasswd.users icingaadmin ${password}",
    cwd     => '/etc/icinga',
  }

  # We enable support for empty hostgroups, which in turn allows
  # for services to be defined without any hosts.  Not good if a
  # host disappears, it was the last service consumer and the
  # whole shebang died!!
  # Note: This is tied to the backported binaries in the install
  #       phase
  file { '/etc/icinga/icinga.cfg':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dc_icinga/icinga.cfg.erb'),
    notify  => Service['icinga'],
  }

  # This need to setuid to root to work from the icinga user
  file { '/usr/lib/nagios/plugins/check_dhcp':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '4755',
  }

  # Add custom plugins
  include dc_icinga::server::custom_plugins

  ######################################################################
  # Pre configuration
  ######################################################################

  # Annoyingly we can't just purge the directory of untracked files
  # when performing the chmod at the end as all of the nagios
  # generated files get nuked as well.  It's safer this way as
  # puppet leaves old definitions around when you change names
  exec { 'icinga_purge':
    command => "/bin/rm -f ${dc_commands_file} ${obj_path}/*",
  }

  ######################################################################
  # Defaults
  ######################################################################

  # Created files are 0600 which are unreadable by the icinga user
  # so ensure the perms are changed before notifying icinga to
  # pick up the changes

  File {
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Exec['icinga_purge'],
    notify  => Service['icinga'],
  }

  file { $dc_timeperiods_file: }
  file { $dc_contacts_file: }
  file { $dc_hostgroups_file: }
  file { $dc_servicegroups_file: }
  file { $dc_hosts_file: }
  file { $dc_services_file: }
  file { $dc_commands_file: }

  # All nagios definitions depend on the directory being purged
  # and happen before the files are chmodded

  Nagios_timeperiod {
    target  => $dc_timeperiods_file,
    require => Exec['icinga_purge'],
    before  => File[$dc_timeperiods_file],
  }

  Nagios_contactgroup {
    target  => $dc_contacts_file,
    require => Exec['icinga_purge'],
    before  => File[$dc_contacts_file],
  }

  Nagios_contact {
    target  => $dc_contacts_file,
    require => Exec['icinga_purge'],
    before  => File[$dc_contacts_file],
  }

  Nagios_hostgroup {
    target  => $dc_hostgroups_file,
    require => Exec['icinga_purge'],
    before  => File[$dc_hostgroups_file],
  }

  Nagios_servicegroup {
    target  => $dc_servicegroups_file,
    require => Exec['icinga_purge'],
    before  => File[$dc_servicegroups_file],
  }

  Nagios_host {
    target  => $dc_hosts_file,
    require => Exec['icinga_purge'],
    before  => File[$dc_hosts_file],
  }

  Nagios_service {
    target  => $dc_services_file,
    require => Exec['icinga_purge'],
    before  => File[$dc_services_file],
  }

  Nagios_command {
    target  => $dc_commands_file,
    require => Exec['icinga_purge'],
    before  => File[$dc_commands_file],
  }

  ######################################################################
  # Service periods
  ######################################################################

  nagios_timeperiod { 'dc_timeperiod_24x7':
    alias     => '24 Hours A Day, 7 Days A Week',
    sunday    => '00:00-24:00',
    monday    => '00:00-24:00',
    tuesday   => '00:00-24:00',
    wednesday => '00:00-24:00',
    thursday  => '00:00-24:00',
    friday    => '00:00-24:00',
    saturday  => '00:00-24:00',
  }

  ######################################################################
  # Contact groups
  ######################################################################

  nagios_contactgroup { 'dc_admins':
    alias  => 'Icinga Administrators',
  }

  ######################################################################
  # Contacts
  ######################################################################

  nagios_contact { 'sysadmin':
    alias                         => 'System Administrators',
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

  nagios_host { 'dc_host_generic':
    notifications_enabled        => '1',
    event_handler_enabled        => '1',
    flap_detection_enabled       => '1',
    failure_prediction_enabled   => '1',
    process_perf_data            => '1',
    retain_status_information    => '1',
    retain_nonstatus_information => '1',
    check_command                => 'check-host-alive',
    max_check_attempts           => '10',
    notification_interval        => '0',
    notification_period          => 'dc_timeperiod_24x7',
    notification_options         => 'd,u,r',
    contact_groups               => 'dc_admins',
    register                     => '0',
  }

  ######################################################################
  # Service templates
  ######################################################################

  nagios_service { 'dc_service_generic':
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

  nagios_hostgroup { 'dc_hostgroup_generic':
    alias   => 'All Hosts',
    members => '*',
  }

  nagios_hostgroup { 'dc_hostgroup_http':
    alias => 'HTTP Servers',
  }

  nagios_hostgroup { 'dc_hostgroup_https':
    alias => 'HTTPS Servers',
  }

  nagios_hostgroup { 'dc_hostgroup_puppetmaster':
    alias => 'Puppet Masters',
  }

  nagios_hostgroup { 'dc_hostgroup_postgres':
    alias => 'PostgreSQL Servers',
  }

  nagios_hostgroup { 'dc_hostgroup_dhcp':
    alias => 'DHCP Servers',
  }

  nagios_hostgroup { 'dc_hostgroup_tftp':
    alias => 'TFTP Servers',
  }

  nagios_hostgroup { 'dc_hostgroup_dns':
    alias => 'DNS Servers',
  }

  nagios_hostgroup { 'dc_hostgroup_ntp':
    alias => 'NTP Servers',
  }

  nagios_hostgroup { 'dc_hostgroup_puppetdb':
    alias => 'Puppet DB Servers',
  }

  nagios_hostgroup { 'dc_hostgroup_foreman_proxy':
    alias => 'Foreman Proxies',
  }

  nagios_hostgroup { 'dc_hostgroup_mysql':
    alias => 'MySQL Servers',
  }

  nagios_hostgroup { 'dc_hostgroup_logstashes':
    alias => 'Logstash ElasticSearch Servers',
  }

  nagios_hostgroup { 'dc_hostgroup_keystone':
    alias => 'Openstack Keystone Servers',
  }

  nagios_hostgroup { 'dc_hostgroup_nfs':
    alias => 'NFS Servers',
  }

  nagios_hostgroup { 'dc_hostgroup_foreman':
    alias => 'Foreman Servers',
  }

  nagios_hostgroup { 'dc_hostgroup_smtp':
    alias => 'SMTP Servers',
  }

  nagios_hostgroup { 'dc_hostgroup_postfix':
    alias => 'Postfix Servers',
  }

  nagios_hostgroup { 'dc_hostgroup_nova_compute':
    alias => 'Openstack Compute Nodes',
  }

  nagios_hostgroup { 'dc_hostgroup_neutron_node':
    alias => 'Openstack Neutron Nodes',
  }

  nagios_hostgroup { 'dc_hostgroup_neutron_server':
    alias => 'Openstack Neutron Servers',
  }

  nagios_hostgroup { 'dc_hostgroup_nova_server':
    alias => 'Openstack Nova Servers',
  }

  nagios_hostgroup { 'dc_hostgroup_rabbitmq':
    alias => 'RabbitMQ Nodes',
  }

  nagios_hostgroup { 'dc_hostgroup_glance':
    alias => 'Glance Servers',
  }

  nagios_hostgroup { 'dc_hostgroup_ldap':
    alias => 'LDAP Servers',
  }

  nagios_hostgroup { 'dc_hostgroup_cinder':
    alias => 'Cinder Servers',
  }
  ######################################################################
  ######################################################################
  # Commands
  ######################################################################
  # Define custom commands not provided by nagios-plugins
  ######################################################################

  nagios_command { 'notify-host-by-email':
    command_line => '/usr/bin/printf "%b" "***** Icinga *****\n\nNotification Type: $NOTIFICATIONTYPE$\nHost: $HOSTNAME$\nState: $HOSTSTATE$\nAddress: $HOSTADDRESS$\nInfo: $HOSTOUTPUT$\n\nDate/Time: $LONGDATETIME$\n" | /usr/bin/mail -s "** $NOTIFICATIONTYPE$ Host Alert: $HOSTNAME$ is $HOSTSTATE$ **" $CONTACTEMAIL$',
  }

  nagios_command { 'notify-service-by-email':
    command_line => '/usr/bin/printf "%b" "***** Icinga *****\n\nNotification Type: $NOTIFICATIONTYPE$\n\nService: $SERVICEDESC$\nHost: $HOSTALIAS$\nAddress: $HOSTADDRESS$\nState: $SERVICESTATE$\n\nDate/Time: $LONGDATETIME$\n\nAdditional Info:\n\n$SERVICEOUTPUT$\n" | /usr/bin/mail -s "** $NOTIFICATIONTYPE$ Service Alert: $HOSTALIAS$/$SERVICEDESC$ is $SERVICESTATE$ **" $CONTACTEMAIL$',
  }

  nagios_command { 'check_pgsql_dc':
    command_line => '/usr/lib/nagios/plugins/check_pgsql -H $HOSTADDRESS$ -d $ARG1$ -l $ARG2$ -p $ARG3$',
  }

  nagios_command { 'check_ntp_dc':
    command_line => '/usr/lib/nagios/plugins/check_ntp_time -H $HOSTADDRESS$',
  }

  nagios_command { 'check_foreman_proxy_dc':
    command_line => '/usr/lib/nagios/plugins/check_http -H $HOSTADDRESS$ --ssl -p 8443 -u /version',
  }

  nagios_command { 'check_tftp_dc':
    command_line => '/usr/lib/nagios/plugins/check_tftp -H $HOSTADDRESS$ -p nagios_test_file',
  }

  nagios_command { 'check_mysql_dc':
    command_line => "/usr/lib/nagios/plugins/check_mysql -H \$HOSTADDRESS$ -u icinga -p ${mariadb_icinga_pw}",
  }

  nagios_command { 'check_nfs_dc':
    command_line => '/usr/lib/nagios/plugins/check_rpc -H $HOSTADDRESS$ -C nfs -c2,3,4',
  }

  nagios_command { 'check_keystone_dc':
    command_line => "/usr/lib/nagios/plugins/check_keystone --auth_url http://\$HOSTADDRESS\$:5000/v2.0 --username icinga --password ${keystone_icinga_password} --tenant icinga"
  }

  nagios_command { 'check_foreman_dc':
    command_line => "/usr/lib/nagios/plugins/check_foreman -H \$HOSTADDRESS$ -l icinga -a ${foreman_icinga_pw}"
  }

  nagios_command { 'check_nova_ec2_api':
    command_line => "/usr/lib/nagios/plugins/check_http -u /services/Cloud/ -H \$HOSTADDRESS$ -p 8773"
  }

  nagios_command { 'check_nova_os_api':
    command_line => "/usr/lib/nagios/plugins/check_http -H \$HOSTADDRESS$ -p 8774"
  }

  nagios_command { 'check_nova_os_metadata_api':
    command_line => "/usr/lib/nagios/plugins/check_http -H \$HOSTADDRESS$ -p 8775"
  }

  nagios_command { 'check_neutron_api':
    command_line => "/usr/lib/nagios/plugins/check_http -H \$HOSTADDRESS$ -p 9696"
  }

  nagios_command { 'check_rabbitmq_aliveness':
    command_line => "/usr/lib/nagios/plugins/check_rabbitmq_aliveness -u ${rabbitmq_monuser} -p ${rabbitmq_monuser_password} -H \$HOSTADDRESS$ --port=15672"
  }

  nagios_command { 'check_rabbitmq_server':
    command_line => "/usr/lib/nagios/plugins/check_rabbitmq_server -u ${rabbitmq_monuser} -p ${rabbitmq_monuser_password} -H \$HOSTNAME$ --port=15672"
  }

  nagios_command { 'check_rabbitmq_overview':
    command_line => "/usr/lib/nagios/plugins/check_rabbitmq_overview -u ${rabbitmq_monuser} -p ${rabbitmq_monuser_password} -H \$HOSTADDRESS$ --port=15672"
  }

  nagios_command { 'check_rabbitmq_watermark':
    command_line => "/usr/lib/nagios/plugins/check_rabbitmq_watermark -u ${rabbitmq_monuser} -p ${rabbitmq_monuser_password} -H \$HOSTNAME$ --port=15672"
  }

  nagios_command { 'check_rabbitmq_partition':
    command_line => "/usr/lib/nagios/plugins/check_rabbitmq_partition -u ${rabbitmq_monuser} -p ${rabbitmq_monuser_password} -H \$HOSTNAME$ --port=15672"
  }

  nagios_command { 'check_rabbitmq_shovels':
    command_line => "/usr/lib/nagios/plugins/check_rabbitmq_shovels -u ${rabbitmq_monuser} -p ${rabbitmq_monuser_password} -H \$HOSTADDRESS$ --port=15672"
  }

  nagios_command { 'check_rabbitmq_queue':
    command_line => "/usr/lib/nagios/plugins/check_rabbitmq_queue -u ${rabbitmq_monuser} -p ${rabbitmq_monuser_password} -H \$HOSTADDRESS$ --port=15672"
  }

  nagios_command { 'check_rabbitmq_objects':
    command_line => "/usr/lib/nagios/plugins/check_rabbitmq_objects -u ${rabbitmq_monuser} -p ${rabbitmq_monuser_password} -H \$HOSTADDRESS$ --port=15672"
  }

  nagios_command { 'check_glance_http':
    command_line => "/usr/lib/nagios/plugins/check_http -H \$HOSTADDRESS$ -p 9292"
  }

  nagios_command { 'check_glance_registry_http':
    command_line => "/usr/lib/nagios/plugins/check_http -e 401 -H \$HOSTADDRESS$ -p 9191"
  }

  nagios_command { 'check_dc_ldap':
    command_line => "/usr/lib/nagios/plugins/check_ldap -H \$HOSTADDRESS$ -b ${ldap_server_suffix}"
  }
  
  nagios_command { 'check_cinder_api_http':
    command_line => "/usr/lib/nagios/plugins/check_http -H \$HOSTADDRESS$ -p 8776"
  }
  ######################################################################
  ######################################################################

  include dc_icinga::server::nagios_services

  ######################################################################
  ######################################################################
  # Per client storeconfig data
  ######################################################################

  # Imports don't pick up the defaults for some reason
  Nagios_host <<||>> {
    target  => $dc_hosts_file,
    require => Exec['icinga_purge'],
    before  => File[$dc_hosts_file],
  }

}


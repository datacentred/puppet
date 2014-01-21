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
  $password = 'dcsal01dev',
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

  # Custom nagios plugins
  file { '/usr/lib/nagios/plugins/check_tftp':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/dc_icinga/check_tftp',
  }

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
    email                         => hiera(sysmailaddress),
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
    alias => 'TFPT Servers',
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

  ######################################################################
  # Services
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


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

  include dc_icinga::params
  $cfg_path = $::dc_icinga::params::cfg_path

  # When doing a non interactive install the password isn't generated
  # so do that for us first time around
  exec { 'icinga_cgi_passwd':
    command     => '/usr/bin/htpasswd -c -b htpasswd.users icingaadmin icinga',
    cwd         => '/etc/icinga',
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

  ######################################################################
  # Pre configuration
  ######################################################################

  # Annoyingly we can't just purge the directory of untracked files
  # when performing the chmod at the end as all of the nagios
  # generated files get nuked as well.  It's safer this way as
  # puppet leaves old definitions around when you change names
  exec { 'icinga_purge':
    command => "/bin/rm ${cfg_path}/*",
  }

  ######################################################################
  # Defaults
  ######################################################################

  Nagios_timeperiod {
    target  => "${cfg_path}/dc_timeperiods.cfg",
    require => Exec['icinga_purge'],
    before  => File['icinga_chmod'],
    notify  => Service['icinga'],
  }

  Nagios_contactgroup {
    target  => "${cfg_path}/dc_contacts.cfg",
    require => Exec['icinga_purge'],
    before  => File['icinga_chmod'],
    notify  => Service['icinga'],
  }

  Nagios_contact {
    target  => "${cfg_path}/dc_contacts.cfg",
    require => Exec['icinga_purge'],
    before  => File['icinga_chmod'],
    notify  => Service['icinga'],
  }

  Nagios_hostgroup {
    target  => "${cfg_path}/dc_hostgroups.cfg",
    require => Exec['icinga_purge'],
    before  => File['icinga_chmod'],
    notify  => Service['icinga'],
  }

  Nagios_servicegroup {
    target  => "${cfg_path}/dc_servicegroups.cfg",
    require => Exec['icinga_purge'],
    before  => File['icinga_chmod'],
    notify  => Service['icinga'],
  }

  Nagios_host {
    target  => "${cfg_path}/dc_hosts.cfg",
    require => Exec['icinga_purge'],
    before  => File['icinga_chmod'],
    notify  => Service['icinga'],
  }

  Nagios_service {
    target  => "${cfg_path}/dc_services.cfg",
    require => Exec['icinga_purge'],
    before  => File['icinga_chmod'],
    notify  => Service['icinga'],
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

  nagios_contact { 'matt':
    alias                         => 'Matt Jarvis',
    #email                         => 'matt.jarvis@datacentred.co.uk',
    email                         => 'root@localhost',
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
    check_command       => 'check_pgsql',
    service_description => 'PostgreSQL',
  }

  nagios_service { 'check_dhcp':
    use                 => 'dc_service_generic',
    hostgroup_name      => 'dc_hostgroup_dhcp',
    check_command       => 'check_dhcp',
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
    check_command       => 'check_ntp',
    service_description => 'NTP',
  }

  ######################################################################
  # Per client storeconfig data
  ######################################################################

  Nagios_host <<||>> {
    target  => "${cfg_path}/dc_hosts.cfg",
    require => Exec['icinga_purge'],
    before  => File['icinga_chmod'],
    notify  => Service['icinga'],
  }

  ######################################################################
  # Post configuration
  ######################################################################

  # When puppet creates the nagios congiuration files they
  # are 0600 ergo un readable by icinga, so modify them pre
  # refresh
  file { 'icinga_chmod':
    ensure  => directory,
    path    => $cfg_path,
    mode    => '0644',
    recurse => true,
  }

}


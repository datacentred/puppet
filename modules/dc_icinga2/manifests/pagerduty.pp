# == Class: dc_icinga2::pagerduty
#
# Pagerduty notification support
#
class dc_icinga2::pagerduty (
  $pager,
) {

  include ::dc_icinga2::pagerduty::agent

  icinga2::object::user { 'pagerduty':
    display_name => 'PagerDuty Notification User',
    groups       => [ 'icingaadmins' ],
    pager        => $pager,
    states       => [ 'OK', 'Warning', 'Critical', 'Unknown', 'Up', 'Down' ],
    types        => [ 'Problem', 'Recovery' ],
    target       => '/etc/icinga2/zones.d/global-templates/users.conf',
  }

  icinga2::object::notificationcommand { 'notify-host-by-pagerduty':
    import  => 'plugin-notification-command',
    command => '/usr/local/bin/pagerduty_icinga.pl enqueue -f pd_nagios_object=host',
    env     => {
      'ICINGA_CONTACTPAGER'     => '$user.pager$',
      'ICINGA_NOTIFICATIONTYPE' => '$notification.type$',
      'ICINGA_HOSTNAME'         => '$host.name$',
      'ICINGA_HOSTALIAS'        => '$host.display_name$',
      'ICINGA_HOSTSTATE'        => '$host.state$',
      'ICINGA_HOSTOUTPUT'       => '$host.output$',
    },
    target  => '/etc/icinga2/zones.d/global-templates/notifications.conf',
  }

  icinga2::object::notificationcommand { 'notify-service-by-pagerduty':
    import  => 'plugin-notification-command',
    command => '/usr/local/bin/pagerduty_icinga.pl enqueue -f pd_nagios_object=service',
    env     => {
      'ICINGA_CONTACTPAGER'     => '$user.pager$',
      'ICINGA_NOTIFICATIONTYPE' => '$notification.type$',
      'ICINGA_SERVICEDESC'      => '$service.name$',
      'ICINGA_HOSTNAME'         => '$host.name$',
      'ICINGA_HOSTALIAS'        => '$host.display_name$',
      'ICINGA_SERVICESTATE'     => '$service.state$',
      'ICINGA_SERVICEOUTPUT'    => '$service.output$',
    },
    target  => '/etc/icinga2/zones.d/global-templates/notifications.conf',
  }

  icinga2::object::apply_notification { 'pagerduty-host':
    object       => 'Host',
    command      => 'notify-host-by-pagerduty',
    states       => [ 'Up', 'Down' ],
    types        => ['Problem', 'Acknowledgement', 'Recovery' ],
    period       => '24x7',
    users        => [ 'pagerduty' ],
    assign_where => 'host.vars.enable_pagerduty == true',
    target       => '/etc/icinga2/zones.d/global-templates/notifications.conf',
  }

  icinga2::object::apply_notification { 'pagerduty-service':
    object       => 'Service',
    command      => 'notify-service-by-pagerduty',
    states       => [ 'OK', 'Warning', 'Critical', 'Unknown' ],
    types        => [ 'Problem', 'Acknowledgement', 'Recovery' ],
    period       => '24x7',
    users        => [ 'pagerduty' ],
    assign_where => 'service.vars.enable_pagerduty == true',
    target       => '/etc/icinga2/zones.d/global-templates/notifications.conf',
  }

}

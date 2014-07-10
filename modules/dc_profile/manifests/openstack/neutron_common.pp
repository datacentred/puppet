# Class: dc_profile::openstack::neutron_common
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::neutron_common {

  # Limit the amount of spam that the neutron heartbeat generates
  # See https://bugs.launchpad.net/neutron/+bug/1310571 as an
  # example description
  file_line { 'neutron_sudoers_default':
    path      => '/etc/sudoers.d/neutron_sudoers',
    line      => 'Defaults:neutron !requiretty, syslog_badpri=err, syslog_goodpri=info',
    match     => 'Defaults:neutron !requiretty',
    subscribe => Package['neutron-common'],
  }

  if $::environment == 'production'
  {
    file { '/etc/nagios/nrpe.d/os_neutron_vswitch_agent.cfg':
      ensure  => present,
      content => 'command[check_neutron_vswitch_agent]=/usr/lib/nagios/plugins/check_procs -c 1 -u neutron -a neutron-openvswitch-agent',
      require => Package['nagios-nrpe-server'],
      notify  => Service['nagios-nrpe-server'],
    }

    file { '/etc/nagios/nrpe.d/os_ovswitch_proc.cfg':
      ensure  => present,
      content => 'command[check_ovswitch_proc]=/usr/lib/nagios/plugins/check_procs -w 2: -C ovs-vswitchd',
      require => Package['nagios-nrpe-server'],
      notify  => Service['nagios-nrpe-server'],
    }

    file { '/etc/nagios/nrpe.d/os_ovswitch_server_proc.cfg':
      ensure  => present,
      content => 'command[check_ovswitch_server_proc]=/usr/lib/nagios/plugins/check_procs -w 2: -C ovsdb-server',
      require => Package['nagios-nrpe-server'],
      notify  => Service['nagios-nrpe-server'],
    }
  }

  include dc_profile::openstack::neutron_logstash
  
}

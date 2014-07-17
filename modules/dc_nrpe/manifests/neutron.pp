# Class: dc_nrpe::neutron
#
# Neutron specific nrpe configuration
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_nrpe::neutron {

  $keystone_port            = hiera(keystone_port)
  $os_api_host              = hiera(os_api_host)
  $neutron_api_port         = hiera(neutron_api_port)
  $keystone_icinga_tenant   = hiera(keystone_icinga_tenant)
  $keystone_icinga_password = hiera(keystone_icinga_password)
  $keystone_icinga_user     = hiera(keystone_icinga_user)

  if defined(Class['dc_icinga::hostgroup_neutron']) {

    file { '/etc/nagios/nrpe.d/neutron_server_netstat.cfg':
      ensure  => present,
      content => "command[check_neutron_server_netstat]=sudo /usr/lib/nagios/plugins/check_neutron-server.sh -H http://${os_api_host}:${keystone_port}/v2.0 -E http://${os_api_host}:${neutron_api_port}/v2.0 -T ${keystone_icinga_tenant} -U ${keystone_icinga_user} -P ${keystone_icinga_password}",
      require => Package['nagios-nrpe-server'],
      notify  => Service['nagios-nrpe-server'],
    }

    file { '/etc/nagios/nrpe.d/os_neutron_server.cfg':
      ensure  => present,
      content => 'command[check_neutron_server]=/usr/lib/nagios/plugins/check_procs -c 1: -u neutron -a /usr/bin/neutron-server',
      require => Package['nagios-nrpe-server'],
      notify  => Service['nagios-nrpe-server'],
    }

    sudo::conf { 'check_neutron_server':
      priority    => 10,
      content     => 'nagios ALL=NOPASSWD:/usr/lib/nagios/plugins/check_neutron-server.sh',
    }

    file { '/usr/lib/nagios/plugins/check_neutron-server.sh':
      ensure  => file,
      source  => 'puppet:///modules/dc_nrpe/check_neutron-server.sh',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => Package['nagios-nrpe-server'],
      notify  => Service['nagios-nrpe-server'],
    }
  }
}

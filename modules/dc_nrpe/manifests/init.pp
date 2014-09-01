# Class: dc_nrpe
#
# Installs and configures nagios nrpe server
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
# FIXME add sudo support, add ability to add options
class dc_nrpe (
  $allowed_hosts = '127.0.0.1',
  $ensure_nagios = stopped,
){

  contain dc_nrpe::install

  # Puppet checks

  package { 'python-yaml':
    ensure => installed,
  }

  file { '/usr/lib/nagios/plugins/check_puppetagent':
    ensure  => file,
    require => Package['nagios-nrpe-server'],
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'puppet:///modules/dc_nrpe/check_puppetagent',
  }

  sudo::conf { 'check_puppetagent':
    priority => 10,
    content  => 'nagios ALL=NOPASSWD:/usr/lib/nagios/plugins/check_puppetagent',
  }

  contain dc_nrpe::cinder
  contain dc_nrpe::glance
  contain dc_nrpe::neutron
  contain dc_nrpe::nova_compute
  contain dc_nrpe::nova_server
  contain dc_nrpe::logstash
  contain dc_nrpe::smartd
  contain dc_nrpe::ceph

}

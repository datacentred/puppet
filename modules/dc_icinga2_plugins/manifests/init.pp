# == Class: dc_icinga2_plugins
#
# Installs and manages bespoke icinga/nagios plugins
#
class dc_icinga2_plugins {

  File {
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { [
    '/usr/local/lib/nagios',
    '/usr/local/lib/nagios/plugins',
  ]:
    ensure => directory,
  }

  file { '/usr/local/lib/nagios/plugins/check_bmc':
    source => 'puppet:///modules/dc_icinga2_plugins/check_bmc',
  }

  file { '/usr/local/lib/nagios/plugins/check_ceph_health':
    source => 'puppet:///modules/dc_icinga2_plugins/check_ceph_health',
  }

  file { '/usr/local/lib/nagios/plugins/check_ceph_mon':
    source => 'puppet:///modules/dc_icinga2_plugins/check_ceph_mon',
  }

  file { '/usr/local/lib/nagios/plugins/check_ceph_osd':
    source => 'puppet:///modules/dc_icinga2_plugins/check_ceph_osd',
  }

  file { '/usr/local/lib/nagios/plugins/check_ceph_rgw':
    source => 'puppet:///modules/dc_icinga2_plugins/check_ceph_rgw',
  }

  file { '/usr/local/lib/nagios/plugins/check_nova_service':
    source => 'puppet:///modules/dc_icinga2_plugins/check_nova_service',
  }

  file { '/usr/local/lib/nagios/plugins/check_pgsql_replication':
    source => 'puppet:///modules/dc_icinga2_plugins/check_pgsql_replication',
  }

  file { '/usr/local/lib/nagios/plugins/check_psu':
    source => 'puppet:///modules/dc_icinga2_plugins/check_psu',
  }

  file { '/usr/local/lib/nagios/plugins/check_sas_phy':
    source => 'puppet:///modules/dc_icinga2_plugins/check_sas_phy',
  }

  package { 'nagios-plugin-check-scsi-smart': }

}

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

  file { '/usr/local/lib/nagios/plugins/check_neutron_api':
    source => 'puppet:///modules/dc_icinga2_plugins/check_neutron_api',
  }

  file { '/usr/local/lib/nagios/plugins/check_openstack_service':
    source => 'puppet:///modules/dc_icinga2_plugins/check_openstack_service',
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

  file { '/usr/local/lib/nagios/plugins/check_ceph_memory':
    source => 'puppet:///modules/dc_icinga2_plugins/check_ceph_memory',
  }

  file { '/usr/local/lib/nagios/plugins/check_disk_queue':
    source => 'puppet:///modules/dc_icinga2_plugins/check_disk_queue',
  }

  file { '/usr/local/lib/nagios/plugins/check_disk_latency':
    source => 'puppet:///modules/dc_icinga2_plugins/check_disk_latency',
  }

  file { '/usr/local/lib/nagios/plugins/check_log_courier':
    source => 'puppet:///modules/dc_icinga2_plugins/check_log_courier',
  }

  file { '/usr/local/lib/nagios/plugins/check_memory_edac':
    source => 'puppet:///modules/dc_icinga2_plugins/check_memory_edac',
  }

  package { 'nagios-plugin-check-scsi-smart': }

}

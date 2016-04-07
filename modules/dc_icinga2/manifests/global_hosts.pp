# == Class: dc_icinga2::global_hosts
#
# Defines virtual hosts for S3/OpenStack API checks
#
class dc_icinga2::global_hosts {

  icinga2::object::endpoint { 'compute.datacentred.io': }

  icinga2::object::zone { 'compute.datacentred.io':
    endpoints => [
      'compute.datacentred.io',
    ],
    parent    => 'icinga2.core.sal01.datacentred.co.uk',
  }

  icinga2::object::host { 'compute.datacentred.io':
    import     => 'virtual-host',
    address    => '185.43.218.26',
    zone       => 'icinga2.core.sal01.datacentred.co.uk',
    vars       => {
      'role' => 'openstack-endpoint',
    },
    icon_image => 'http://incubator.storage.datacentred.io/openstack-logo-16x16.png',
    target     => '/etc/icinga2/zones.d/compute.datacentred.io/hosts.conf',
  }

  icinga2::object::endpoint { 'storage.datacentred.io': }

  icinga2::object::zone { 'storage.datacentred.io':
    endpoints => [
      'storage.datacentred.io',
    ],
    parent    => 'icinga2.core.sal01.datacentred.co.uk',
  }

  icinga2::object::host { 'storage.datacentred.io':
    import     => 'virtual-host',
    address    => '185.43.218.55',
    zone       => 'icinga2.core.sal01.datacentred.co.uk',
    vars       => {
      'role' => 'rados-endpoint',
    },
    icon_image => 'http://incubator.storage.datacentred.io/ceph-logo-16x16.png',
    target     => '/etc/icinga2/zones.d/storage.datacentred.io/hosts.conf',
  }

}

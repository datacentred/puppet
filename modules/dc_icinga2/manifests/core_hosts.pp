# == Class: dc_icinga2::core_hosts
#
# Defines virtual hosts for S3/OpenStack API checks
#
class dc_icinga2::core_hosts {

  dc_icinga2::virtual_host { 'compute.datacentred.io':
    address    => '185.43.218.26',
    vars       => {
      'role'                             => 'openstack-endpoint',
      'certificates["*.datacentred.io"]' => {
        'port' => 443,
      },
    },
    icon_image => 'http://incubator.storage.datacentred.io/openstack-logo-16x16.png',
  }

  dc_icinga2::virtual_host { 'storage.datacentred.io':
    address    => '185.43.218.55',
    vars       => {
      'role'                                     => 'rados-endpoint',
      'certificates["*.storage.datacentred.io"]' => {
        'port' => 443,
      },
    },
    icon_image => 'http://incubator.storage.datacentred.io/ceph-logo-16x16.png',
  }

  dc_icinga2::virtual_host { 'jenkins.datacentred.services':
    address    => '185.43.217.42',
    vars       => {
      'role'                                   => 'jenkins-endpoint',
      'certificates["*.datacentred.services"]' => {
        'port' => 8080,
      },
    },
    icon_image => 'http://incubator.storage.datacentred.io/jenkins-logo-16x16.png',
  }

}

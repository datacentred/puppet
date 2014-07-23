class dc_ssl::haproxy {

  file { '/etc/ssl/certs/haproxy.pem':
    ensure => absent,
  }

  file { '/etc/ssl/certs/osapi_sal01_datacentred_co_uk.pem':
    source => 'puppet:///modules/dc_ssl/haproxy/osapi_sal01_datacentred_co_uk.pem',
  }

  file { '/etc/ssl/certs/openstack_datacentred_io.pem':
    source => 'puppet:///modules/dc_ssl/haproxy/openstack_datacentred_io.pem',
  }

}

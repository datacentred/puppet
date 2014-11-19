# == Class: dc_ssl::haproxy
#
class dc_ssl::haproxy {

  file { '/etc/ssl/certs/haproxy.pem':
    ensure => absent,
  }

  file { '/etc/ssl/certs/osapi_sal01_datacentred_co_uk.pem':
    ensure => absent,
  }

  file { '/etc/ssl/certs/openstack_datacentred_io.pem':
    ensure => absent,
  }

  file { '/etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem':
    source => 'puppet:///modules/dc_ssl/haproxy/STAR_sal01_datacentred_co_uk.pem',
  }

  file { '/etc/ssl/certs/STAR_datacentred_io.pem':
    source => 'puppet:///modules/dc_ssl/haproxy/STAR_datacentred_io.pem',
  }

  file { '/etc/ssl/certs/logstash.sal01.datacentred.co.uk.pem':
    source => 'puppet:///modules/dc_ssl/haproxy/logstash.sal01.datacentred.co.uk.pem',
  }

}

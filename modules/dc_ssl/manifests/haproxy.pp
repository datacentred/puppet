# == Class: dc_ssl::haproxy
#
class dc_ssl::haproxy {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { '/etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem':
    source => 'puppet:///modules/dc_ssl/haproxy/STAR_sal01_datacentred_co_uk.pem',
  }

  file { '/etc/ssl/certs/STAR_datacentred_io.pem':
    source => 'puppet:///modules/dc_ssl/haproxy/STAR_datacentred_io.pem',
  }

}

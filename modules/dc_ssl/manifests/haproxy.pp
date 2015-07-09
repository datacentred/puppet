# == Class: dc_ssl::haproxy
#
class dc_ssl::haproxy (
  $star_sal01_datacentred_co_uk_pem,
  $star_datacentred_io_pem,
) {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { '/etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem':
    content => $star_sal01_datacentred_co_uk_pem,
  }

  file { '/etc/ssl/certs/STAR_datacentred_io.pem':
    content => $star_datacentred_io_pem,
  }

}

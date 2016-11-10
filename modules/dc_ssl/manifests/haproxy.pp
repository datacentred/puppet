# == Class: dc_ssl::haproxy
#
class dc_ssl::haproxy (
  $star_sal01_datacentred_co_uk_pem,
  $star_datacentred_io_pem,
) {

  $combined_crt = '/etc/ssl/private/puppet.crt'
  $ssl_crt = "/etc/puppetlabs/puppet/ssl/certs/${::fqdn}.pem"
  $ssl_key = "/etc/puppetlabs/puppet/ssl/private_keys/${::fqdn}.pem"

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

  exec { "cat ${ssl_crt} ${ssl_key} > ${combined_crt}; chmod 0400 ${combined_crt}":
    user    => 'root',
    creates => $combined_crt,
  }

}

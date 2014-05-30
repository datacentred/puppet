# Self-signed certificate for haproxy
class dc_ssl::haproxy {

  file { '/etc/ssl/certs/haproxy.pem':
    source => 'puppet:///modules/dc_ssl/haproxy/haproxy.pem',
  }

}

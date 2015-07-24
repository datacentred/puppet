# == Class: loadbalancer::stats
#
class loadbalancer::stats (
  $ipaddress,
  $ports,
  $user,
  $password,
  $ssl_cert = undef,
  $ssl_key = undef,
  $combined_cert = undef,
) {

  if $combined_cert {

    $cert = $combined_cert
    
  } else {
      
    $cert = "/etc/ssl/private/${::fqdn}.crt"

    loadbalancer::cert { $cert:
      ssl_cert => $ssl_cert,
      ssl_key  => $ssl_key,
      before   => Haproxy::Listen['haproxy-stats'],
    }
    
  }
    
  haproxy::listen { 'haproxy-stats':
    mode    => 'http',
    bind    => {
      "${ipaddress}:${ports}" => [
        'ssl',
        'no-sslv3',
        "crt ${cert}",
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options => {
      'stats'  => [
        'enable',
        'uri /',
        'hide-version',
        "auth ${user}:${password}",
      ],
      'rspadd' => 'Strict-Transport-Security:\ max-age=31536000',
    },
  }

}

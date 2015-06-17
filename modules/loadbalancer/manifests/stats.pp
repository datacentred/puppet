# == Class: loadbalancer::stats
#
class loadbalancer::stats (
  $ipaddress,
  $ports,
  $user,
  $password,
  $ssl = false,
  $ssl_cert = undef,
  $ssl_key = undef,
  $combined_cert = undef,
) {

  if $ssl {

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
    
    $bind_options = [
      'ssl',
      'no-sslv3',
      "crt ${cert}",
      'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
    ]

  } else {

    $bind_options = ''

  }

  # NOTE: Yes it's a coding standard violation but a bug exists
  # somewhere with implicit type conversion
  haproxy::listen { 'haproxy-stats':
    ipaddress    => $ipaddress,
    mode         => 'http',
    ports        => "${ports}",
    bind_options => $bind_options,
    options      => {
      'stats' => [
        'enable',
        'uri /',
        'hide-version',
        "auth ${user}:${password}",
      ],
      'rspadd' => 'Strict-Transport-Security:\ max-age=31536000',
    },
  }

}

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
  $cert_override = undef,
) {

  if $ssl {

    if $cert_override {

      $cert = $cert_override
    
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
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
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
      'rspadd' => 'Strict-Transport-Security:\ max-age=60',
    },
  }

}

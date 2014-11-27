# == Define: loadbalancer::cert
#
# Create a haproxy compatible certificate
#
define loadbalancer::cert (
  $ssl_cert,
  $ssl_key
) {

  # Keep it secret, keep it safe
  exec { "cat ${ssl_cert} ${ssl_key} > ${name}; chmod 0400 ${name}":
    user    => 'root',
    creates => $name,
  }

}

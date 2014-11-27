# == Class: loadbalancer::certs
#
class loadbalancer::certs (
  $cert_hash,
) {

  create_resources('loadbalancer::cert', $cert_hash)

}


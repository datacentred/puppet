# == Class: dc_ssl::logstash
#
class dc_ssl::logstash (
  $cert,
  $key,
) {

  File {
    owner => 'puppet',
    group => 'puppet',
  }

  file { '/var/lib/puppet/ssl/certs/logstash.sal01.datacentred.co.uk.pem':
    content => $cert,
    mode    => '0644',
  }

  file { '/var/lib/puppet/ssl/private_keys/logstash.sal01.datacentred.co.uk.pem':
    content => $key,
    mode    => '0640',
  }

}

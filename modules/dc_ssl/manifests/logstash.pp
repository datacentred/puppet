# == Class: dc_ssl::logstash
#
class dc_ssl::logstash {

  file { '/var/lib/puppet/ssl/certs/logstash.sal01.datacentred.co.uk.pem':
    source => 'puppet:///modules/dc_ssl/logstash/certs.logstash.sal01.datacentred.co.uk.pem',
  }

  file { '/var/lib/puppet/ssl/private_keys/logstash.sal01.datacentred.co.uk.pem':
    source => 'puppet:///modules/dc_ssl/logstash/private_keys.logstash.sal01.datacentred.co.uk.pem',
  }

}

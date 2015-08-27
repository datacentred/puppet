# == Class: dc_foreman::comms
#
# Adds certs signed by the puppet CA for Foreman to use for comms with the proxies
#
class dc_foreman::comms (
  $foreman_comms_cert,
  $foreman_comms_key,
){

  file { '/var/lib/puppet/ssl/certs/foreman_comms.priv.datacentred.co.uk.pem':
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0644',
    content => $foreman_comms_cert,
  }

  file { '/var/lib/puppet/ssl/private_keys/foreman_comms.priv.datacentred.co.uk.pem':
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0640',
    content => $foreman_comms_key,
  }

}

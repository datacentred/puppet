# Class: dc_postfix
#
# Installs postfix
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_postfix (
  $internal_sysmail_address,
  $gateway = false,
  $relayhost = 'datacentred.services',
  $sasl_user,
  $sasl_domain,
  $sasl_password,
){

  if $gateway {
    include ::dc_postfix::gateway
  } else {
    include ::dc_postfix::nullclient
  }

}

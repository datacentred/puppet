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
  $excluded_hosts = [],
){

  # Things like loadbalancers listening on :25 by definition cannot
  # have an MTA running on themselves, so filter out rather than
  # including for all roles but one
  if ! ($::fqdn in $excluded_hosts) {

    if $gateway {
      include ::dc_postfix::gateway
    } else {
      include ::dc_postfix::nullclient
    }

  }

}

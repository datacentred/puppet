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
){

  if $gateway {
    include ::dc_postfix::gateway
  } else {
    include ::dc_postfix::nullclient
  }

}

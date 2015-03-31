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
  $primary_mail_server,
  $sal01_internal_sysmail_address,
){

  if $::role != 'mail_gateway' {
    include ::dc_postfix::nullclient
  }
  else {
    include ::dc_postfix::gateway
  }

}

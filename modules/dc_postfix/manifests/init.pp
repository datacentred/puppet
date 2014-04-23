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
class dc_postfix {

  $primary_mail_server = hiera(primary_mail_server)

  if $::fqdn != $primary_mail_server {
    include ::dc_postfix::nullclient
  }
  else {
    include ::dc_postfix::gateway
  }
}

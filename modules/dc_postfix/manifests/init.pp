# Class: dc_postfix
#
# Installs postfix as a mail gateway
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

  include postfix
  include augeas

  contain dc_postfix::users
  contain dc_postfix::virtual
  contain dc_postfix::networks
  contain dc_postfix::gmailrelay
  contain dc_postfix::ratelimit
  contain dc_postfix::debug

}

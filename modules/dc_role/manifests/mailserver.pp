# Class: dc_role::mailserver
#
# Mail server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::mailserver inherits dc_role {

  contain dc_profile::net::mail

}

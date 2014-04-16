# Class: dc_role::mailgateway
#
# Postfix mail gateway
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::mailgateway {

  contain dc_profile::net::mailgateway

}

# Class: dc_profile::hubot::marvin
#
# Provisions a node as a Hubot bot
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::hubot::marvin {
  include ::redis
  include ::hubot

  Class['redis'] -> Class['hubot']

  @@dns_resource { "hubot.${::domain}/CNAME":
    rdata => $::fqdn,
  }
}

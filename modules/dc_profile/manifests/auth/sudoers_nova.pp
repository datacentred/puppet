# Class: dc_profile::auth::sudoers_nova
#
# Grant sudo rights to nova
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::auth::sudoers_nova {

  include sudo

  sudo::conf { 'nova':
    priority => 10,
    content  => 'Defaults: nova !requiretty
nova ALL=(root) NOPASSWD: /usr/bin/nova-rootwrap',
  }

}

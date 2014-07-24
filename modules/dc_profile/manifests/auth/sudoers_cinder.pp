# Class: dc_profile::auth::sudoers_cinder
#
# Grant sudo rights to cinder
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::auth::sudoers_cinder {

  include sudo

  sudo::conf { 'cinder':
    priority => 10,
    content  => 'Defaults: cinder !requiretty
cinder ALL=(root) NOPASSWD: /usr/bin/cinder-rootwrap',
  }

}

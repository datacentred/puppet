# Class: dc_profile::auth::sudoers_neutron
#
# Grant sudo rights to neutron
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::auth::sudoers_neutron {

  include sudo

  # Limit the amount of spam that the neutron heartbeat generates
  # See https://bugs.launchpad.net/neutron/+bug/1310571 as an
  # example description
  sudo::conf { 'neutron':
    priority => 10,
    content  => 'Defaults:neutron !requiretty, syslog_badpri=err, syslog_goodpri=info neutron ALL=(root) NOPASSWD: /usr/bin/neutron-rootwrap',
  }

}

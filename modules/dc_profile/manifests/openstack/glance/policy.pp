# Class: dc_profile::openstack::glance::policy
#
# Manage the Glance policy
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::glance::policy {

  # Only admins can publicize images
  augeas { 'glance_policy_admins_publicize_image':
    incl    => '/etc/glance/policy.json',
    lens    => 'Json.lns',
    changes => "set dict/entry[. = 'publicize_image']/string role:admin",
    notify  => Class['::glance::api'],
  }

}

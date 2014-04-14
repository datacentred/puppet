#
define dc_profile::openstack::keystone_dcadmins (
  $hash = undef,
) {

  keystone_user { "dc_profile::openstack::keystone_dcadmins ${title}":
    ensure   => present,
    enabled  => true,
    password => $hash[$title]['pass'],
    tenant   => 'admin',
  }
  keystone_user_role { "dc_profile::openstack::keystone_dcadmins ${title}":
    ensure => present,
    roles  => admin,
  }

}

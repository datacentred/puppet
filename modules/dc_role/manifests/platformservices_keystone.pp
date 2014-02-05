# Role for the keystone server.
class dc_role::platformservices_keystone{
  class { 'dc_profile::keystone_mariadb': } ->
  class { 'dc_profile::os_keystone': }
}

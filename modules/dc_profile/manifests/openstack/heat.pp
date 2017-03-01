# Class: dc_profile::openstack::heat_db
#
# Openstack image API database definitions
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::heat {

  include ::heat
  include ::heat::keystone::auth
  include ::heat::keystone::auth_cfn
  include ::heat::engine
  include ::heat::api
  include ::heat::api_cfn
  include ::heat::keystone::domain

  # Enable 'preview' Stack Adopt and Abandon features
  heat_config {
    'DEFAULT/stack_abandon'          : value => true;
    'DEFAULT/stack_adopt'            : value => true;
    'DEFAULT/keystone_backend'       : value => 'heat.common.heat_keystoneclient.KeystoneClientV3';
    'keystone_authtoken/auth_version': value => '3';
  }

}

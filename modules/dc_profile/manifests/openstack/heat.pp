# == Class: dc_profile::openstack::heat_db
#
class dc_profile::openstack::heat {

  include ::heat
  include ::heat::keystone::auth
  include ::heat::keystone::auth_cfn
  include ::heat::engine
  include ::heat::api
  include ::heat::api_cfn

  # Enable 'preview' Stack Adopt and Abandon features
  heat_config {
    'DEFAULT/stack_abandon'          : value => true;
    'DEFAULT/stack_adopt'            : value => true;
    'DEFAULT/keystone_backend'       : value => 'heat.common.heat_keystoneclient.KeystoneClientV3';
    'keystone_authtoken/auth_version': value => '3';
  }

}

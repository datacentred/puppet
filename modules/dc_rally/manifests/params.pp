# Class: dc_rally::params
#
# Common parameters for installation of Rally / Tempest
class dc_rally::params {
  $auth_url   = 'https://openstack.datacentred.io:5000/v2.0'
  $username   = 'rally'
  $tenant     = 'dcdev'
  $rallyhome  = '/var/local/rally'
}

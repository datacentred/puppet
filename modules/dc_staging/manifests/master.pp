# == Class: dc_staging::master
# 
# The module the staging master server, including API and rundeck
#
class dc_staging::master(
  $staging_packages                   = hiera('dc_staging::master::staging_packages'),
){

  validate_array($staging_packages)
  validate_string($ssl_keyfile)
  validate_string($ssl_certfile)

  ensure_packages($staging_packages)

  include dc_staging::master::api
  include dc_staging::master::dhcp
  include dc_staging::master::interfaces

  include dc_profile::ci::rundeck

}

# Class: dc_profile::netbox
#
# Installs netbox via docker

class dc_profile::net::netbox {
  include ::dc_docker::client
  include ::dc_netbox
}

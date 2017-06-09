# == Class: ::dc_netbox::packages
#

class dc_netbox::packages {

  package { $dc_netbox::requirements:
    ensure => 'installed',
  }

  include ::python

}

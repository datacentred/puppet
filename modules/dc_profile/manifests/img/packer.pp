# Class: dc_profile::img::packer
#
# Packer installation for automated builds of VM images
# Currently just builds 'dcdevbox' for use with Vagrant
#
# Parameters:
#
# Actions:
#
# Requires: dc_packer, puppetlabs-apache
#
# Sample Usage:
#
class dc_profile::img::packer {

  include dc_packer
  include apache

  dc_apache::vhost { 'vboxes':
    docroot     => '/home/packer/output',
  }

}

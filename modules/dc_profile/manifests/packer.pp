# Class:
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
class dc_profile::packer {
  include dc_packer
  include apache

  apache::vhost { 'vboxes':
    docroot     => '/home/packer/output',
    serveradmin => hiera(sysmailaddress),
  }
}

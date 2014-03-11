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

  apache::vhost { "vboxes.${::domain}":
    docroot       => '/home/packer/output',
    port          => '80',
    serveradmin   => hiera(sysmailaddress),
    serveraliases => [ 'vboxes' ],
  }

  @@dns_resource { "vboxes.${::domain}/CNAME":
    rdata => $::fqdn,
  }

}

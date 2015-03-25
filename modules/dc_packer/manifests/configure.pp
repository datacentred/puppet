# == Class: dc_packer::configure
#
# Configures the packer image service for use via HTTP
#
class dc_packer::configure {

  include ::apache

  apache::vhost { "vboxes.${::domain}":
    port          => 80,
    docroot       => '/home/packer/output',
    serveraliases => [ 'vboxes' ],
  }

}

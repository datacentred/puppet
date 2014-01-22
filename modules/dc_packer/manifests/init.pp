# Class: dc_packer
#
# Set up Packer for automated build of DC's development images
#
class dc_packer {
  class { 'dc_packer::user': } ~>
  class { 'dc_packer::install': } ~>
  class { 'dc_packer::schedule': } ~>
  Class ['dc_packer']
}

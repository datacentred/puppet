# Class: dc_packer
#
# Set up Packer for automated build of DC's development images
#
class dc_packer {

  contain ::dc_packer::user
  contain ::dc_packer::install
  contain ::dc_packer::configure
  contain ::dc_packer::schedule

  Class['::dc_packer::user'] ->
  Class['::dc_packer::install'] ->
  Class['::dc_packer::configure'] ->
  Class['::dc_packer::schedule']

}

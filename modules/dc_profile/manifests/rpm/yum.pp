#
# Class: dc_profile::rpm::yum
#
class dc_profile::rpm::yum {

  include ::dc_yum

  # Ensure repos are set up before we attempt to install any packages
  Class['::dc_yum'] -> Package <| |>

}

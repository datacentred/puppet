# == Class: dc_profile::apt::ppa
#
# Installs dependencies for PPA support.
#
# === Details
#
# apt::ppa does support this functionality but requires one and only one ppa
# to have package_manage set to true, which isn't clean or easily managable
# going forward
#
class dc_profile::apt::ppa {

  # Manually install the PPA management package.  This needs to be done before
  # PPAs are installed and apt is updated by ::apt::update.  This  is a work
  # around for the global dependency that ensures all packages are installed
  # after repos are added and apt is updated

  exec { 'apt-get -y install software-properties-common':
    unless => 'dpkg -l | grep software-properties-common',
  } ~>

  exec { 'apt-get update':
    refreshonly => true,
  }

  # Only install PPAs once we are capable

  Class['dc_profile::apt::ppa'] -> Apt::Ppa <||>

}

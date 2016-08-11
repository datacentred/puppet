# == Class: dc_tftp::install
#
# Installs required packages
#
class dc_tftp::install {

  ensure_packages('syslinux')

}

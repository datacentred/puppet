# == Class: dc_elasticsearch::install
#
# Installs pre-requisite packages
#
class dc_elasticsearch::install {

  ensure_packages('curl')

}

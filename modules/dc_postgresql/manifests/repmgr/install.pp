# == Class: dc_postgresql::repmgr::install
#
# Install repmgr components
#
class dc_postgresql::repmgr::install {

  ensure_packages("postgresql-${::dc_postgresql::repmgr::version}-repmgr")

}

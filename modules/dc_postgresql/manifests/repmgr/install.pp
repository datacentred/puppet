# == Class: dc_postgresql::repmgr::install
#
# Install repmgr components
#
class dc_postgresql::repmgr::install {


  ensure_packages(['postgresql-9.3-repmgr', 'repmgr'])

}

# == Class: dc_postgresql::repmgr::install
#
# Install repmgr components
#
class dc_postgresql::repmgr::install {

  package { 'repmgr':
    ensure => installed,
  } ->

  package { 'postgresql-9.3-repmgr':
    ensure => installed,
  }

}

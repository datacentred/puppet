# Class: dc_postgresql
#
# Top level class to install the db
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_postgresql {

  include ::dc_postgresql::params

  class { 'dc_postgresql::install':}
  ->
  class { 'dc_postgresql::repmgr': }
  ->
  class { 'dc_postgresql::config': }
  ->
  class { 'dc_postgresql::keys': }
  ->
  class { 'dc_postgresql::icinga': }
  ->
  class { 'dc_postgresql::databases': }

}

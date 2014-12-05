# == Class: dc_profile::db::postgresql_archive
#
class dc_profile::db::postgresql_archive {

  include ::dc_postgresql
  include ::dc_postgresql::backup
  include ::dc_postgresql::icinga

}

# == Class: dc_postgresql::backup
#
# Postgresql configuration for clustering
#
class dc_postgresql::backup {

  include ::dc_postgresql::params
  include ::dc_postgresql::duplicity_postgresql_base

}

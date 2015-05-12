# == Class: dc_postgresql::backup
#
# Postgresql configuration for clustering
#
class dc_postgresql::backup {

  include ::dc_postgresql::params
  include ::dc_postgresql::duplicity_postgresql_wal
  include ::dc_postgresql::duplicity_postgresql_base

  postgresql::server::config_entry { 'archive_command':
    value => "/var/spool/duplicity/${::hostname}_postgresql_WAL_datacentred_ceph.sh",
  }

}

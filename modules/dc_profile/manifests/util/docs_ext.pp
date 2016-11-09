# Class: dc_profile::util::docs_ext
#
# Manage Confluence installation for external docs host
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
class dc_profile::util::docs_ext {

  include ::java
  include ::dc_confluence
  include ::nginx
  include ::postgresql::server
  include ::dc_backup

  create_resources('postgresql::server::db', hiera_hash('postgresql::server_dbs'))
  create_resources('dc_backup::dc_duplicity_job', hiera_hash('dc_backup::confluence_db_backup'))

  Class['::java'] -> Class['::confluence']

}

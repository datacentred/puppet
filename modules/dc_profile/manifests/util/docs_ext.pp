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
  include ::confluence
  include ::nginx
  include ::postgresql::server
  include ::dc_backup

  create_resources('postgresql::server::db', hiera_hash('postgresql::server_dbs'))

  dc_backup::dc_duplicity_job { "${::fqdn}_confluencexml" :
    cloud          => 's3',
    backup_content => 'homedir',
    source_dir     => '/home/confluence/backups/',
  }

}

# == Class: dc_backups::duplicity
#
# Simple wrapper class to create a backup job using duplicity
#
class dc_backup::duplicity (
  $backup,
) {

  package { 'python-swiftclient':
    ensure => installed,
  }

  create_resources('duplicity', $backup)

}

# == Class: dc_backups::duplicity
#
# Simple wrapper class to create a backup job using duplicity
#
class dc_backup::duplicity (
  $backup,
) {

  create_resources('duplicity', $backup)

}

# == Class: dc_elasticsearch::params
#
# Pull some variables in from hiera so they're accessible everywhere!
#
class dc_elasticsearch::params (
  $backup_name,
  $backup_bucket,
) {}
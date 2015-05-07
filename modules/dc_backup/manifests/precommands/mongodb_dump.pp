# == Class: dc_backup::precommands::mongodb_dump
#
# creates a cron job to dump mongodb's dbs to file
#
class dc_backup::precommands::mongodb_dump (
  $ceilometer_db_password,
) {

  cron { 'daily_mongodb_dump':
    command  => "/usr/bin/mongodump --db ceilometer --username ceilometer --password ${ceilometer_db_password} --out /srv/backup/",
    user     => 'root',
    month    => '*',
    monthday => '*',
    hour     => '0',
    minute   => '0',
  }

}
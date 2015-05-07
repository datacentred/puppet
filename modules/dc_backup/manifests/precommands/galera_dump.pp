# == Class: dc_backup::precommands::galera_dump
#
# creates a cron job to dump galera's dbs to file
#
class dc_backup::precommands::galera_dump (
  $osdbmq_galera_backup_user,
  $osdbmq_galera_backup_pw,
) {

  cron { 'daily_galera_dump':
    command  => "/usr/bin/mysqldump -u ${osdbmq_galera_backup_user} -p${osdbmq_galera_backup_pw} --opt --all-databases | bzcat -zc > /var/local/backup/galera-`date +%Y%m%d-%H%M%S`.sql.bz2",
    user     => 'root',
    month    => '*',
    monthday => '*',
    hour     => '0',
    minute   => '0',
  }

}

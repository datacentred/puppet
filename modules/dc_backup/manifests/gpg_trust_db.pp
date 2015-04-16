# Definition: dc_backup::gpg_trust_db
#
# This class imports trust levels to a trustdb
#
# Parameters:
# - The $cloud to backup to
# - The $pre_command to run before backups
# - The $backup_content describing what service we're backing up
# - The $source_dir to backup from
#
# Sample Usage:
#  dc_backup::dc_duplicity_job { '${::hostname}':
#    cloud          => 's3',
#    backup_content => 'mariadb',
#    source_dir     => '/var/backups/',
#  }
#
define dc_backup::gpg_trust_db (
  $key_fingerprint,
  $trust_level = ':6:',
  $user = root,
) {
  exec { $title :
    command => "echo ${key_fingerprint}${trust_level} > /tmp/${key_fingerprint}.keyid; gpg --import-ownertrust /tmp/${key_fingerprint}.keyid",
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    user    => $user,
    creates => "/tmp/${key_fingerprint}.keyid"
  }
}
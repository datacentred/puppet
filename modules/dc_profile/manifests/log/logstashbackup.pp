# Class: dc_profile::log::logstashbackup
#
# Performs backups of all the logs
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::log::logstashbackup {

  class { 'dc_logstashbackup':
    logstashlocalretention => '14',
    logstashbackupmount    => '/var/lsbackups',
    indicespath            => '/var/lib/logstash/data/elasticsearch/nodes/0/indices',
  }

}

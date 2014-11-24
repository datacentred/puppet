# Class: dc_elasticsearch::elasticsearch_backup
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
class dc_elasticsearch::elasticsearch_backup {

  class { 'dc_logstashbackup':
    logstashlocalretention => '14',
    logstashbackupmount    => '/var/lsbackups',
    indicespath            => '/usr/share/elasticsearch/data/es-01/logstash_platform_services/nodes/0/indices/',
  }

}

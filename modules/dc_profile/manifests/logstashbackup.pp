#
class dc_profile::logstashbackup {

  class { 'dc_logstashbackup':
    logstashlocalretention => '14',
    logstashbackupmount    => '/var/lsbackups',
    indicespath            => '/var/lib/logstash/data/elasticsearch/nodes/0/indices',
  }

}

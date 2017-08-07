# == Class: dc_elasticsearch::snapshot
#
# Create cron jobs to run elasticsearch snapshots and prune old snapshots
#
class dc_elasticsearch::snapshot {

  if $::dc_elasticsearch::backup_node {

    $_backup_name = $dc_elasticsearch::backup_name

    $_data = {
      'type'     => 's3',
      'settings' => {
        'bucket'     => $dc_elasticsearch::backup_bucket,
        'endpoint'   => $dc_elasticsearch::ceph_access_point,
        'access_key' => $dc_elasticsearch::ceph_access_key,
        'secret_key' => $dc_elasticsearch::ceph_private_key,
      },
    }

    # Define the snapshot repository
    exec { 'setup-backup-to-ceph':
      command => inline_template('curl -X PUT localhost:9200/_snapshot/<%= @_backup_name %> -d \'<%= JSON.generate(@_data) %>\''),
      unless  => "curl localhost:9200/_snapshot/ | grep ${_backup_name}",
    }

    # Define the job to create/delete snapshots
    file { '/usr/local/bin/elasticsearch_snapshot':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0744',
      content => 'puppet:///modules/dc_elasticsearch/elasticsearch_snapshot',
    }

    cron { 'elasticsearch_snapshot':
      command => "/usr/local/bin/elasticsearch_snapshot -H localhost -p 9200 -r ${_backup_name} -k 30",
      user    => 'root',
      hour    => 2,
      minute  => 0
    }

  }

}

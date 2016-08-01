# Class: dc_elasticsearch_backup_destination
#
# Configures elasticsearch's backup location(s)
#
class dc_elasticsearch::elasticsearch_backup_destination (
  $backup_name           = $dc_elasticsearch::params::backup_name,
  $backup_bucket         = $dc_elasticsearch::params::backup_bucket,
  $ceph_access_point     = $dc_elasticsearch::params::ceph_access_point,
  $ceph_access_key       = $dc_elasticsearch::params::ceph_access_key,
  $ceph_private_key      = $dc_elasticsearch::params::ceph_private_key,
) inherits dc_elasticsearch::params {
  
  ensure_packages(['curl'])

  exec { 'setup-backup-to-ceph':
    command => "curl -f -XPUT 'http://localhost:9200/_snapshot/${backup_name}' -d '{ \"type\": \"s3\", \"settings\": { \"bucket\": \"${backup_bucket}\", \"endpoint\": \"${ceph_access_point}\", \"access_key\": \"${ceph_access_key}\", \"secret_key\": \"${ceph_private_key}\" } }'",
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    unless  => "curl -f -XGET 'http://localhost:9200/_snapshot/?pretty' | grep \"${backup_name}\"",
    require => Package['curl'],
  }

}

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
  $es_aws_plugin_version = $dc_elasticsearch::params::es_aws_plugin_version,
) inherits dc_elasticsearch::params {
  
  ensure_packages(['curl'])

  exec { 'install_elasticsearch_s3_plugin':
    command => "/usr/share/elasticsearch/bin/plugin install elasticsearch/elasticsearch-cloud-aws/${es_aws_plugin_version}",
    creates => '/usr/share/elasticsearch/plugins/cloud-aws',
    require => Package['elasticsearch'],
  }

  exec { 'setup-backup-to-ceph':
    command => "curl -XPUT 'http://localhost:9200/_snapshot/${backup_name}' -d '{ \"type\": \"s3\", \"settings\": { \"bucket\": \"${backup_bucket}\", \"endpoint\": \"${ceph_access_point}\", \"access_key\": \"${ceph_access_key}\", \"secret_key\": \"${ceph_private_key}\" } }'",
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    unless  => "curl -XGET 'http://localhost:9200/_snapshot/?pretty' | grep \"${backup_name}\"",
    require => Package['curl'],
  }

}
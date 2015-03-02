# == Class: dc_kibana::config
#
class dc_kibana::config {
  file { 'kibana.yml':
    path    => '/var/www/kibana/kibana.yml',
    owner   => 'www-data',
    group   => 'root',
    mode    => '0644',
    content => template('dc_kibana/kibana.yml.erb'),
  }
}

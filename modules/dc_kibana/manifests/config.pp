class dc_kibana::config {
 file { 'config.js':
    path    => '/var/www/kibana/config.js',
    owner   => 'www-data',
    group   => 'root',
    mode    => '0644',
    content => template('dc_kibana/config.js.erb'),
  }
}

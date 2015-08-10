# Class: dc_logstash::server::courier
#
# Install the server side components of log-courier
#
class dc_logstash::server::courier {

  include dc_logstash::server

  $version = $dc_logstash::server::logcourier_version
  $gem = "log-courier-${version}.gem"
  $gem_path = "/opt/logstash/${gem}"

  File {
    ensure => file,
    owner  => 'logstash',
    group  => 'logstash',
    mode   => '0664',
  }

  Package['logstash'] ->

  file { $gem_path:
    source => "puppet:///modules/dc_logstash/log_courier/${gem}",
  } ->

  exec { 'install_log_courier_gem':
    cwd         => '/opt/logstash',
    environment => 'GEM_HOME=vendor/bundle/jruby/1.9',
    command     => "java -jar vendor/jar/jruby-complete-*.jar -S gem install ${gem_path}",
    unless      => 'java -jar vendor/jar/jruby-complete-*.jar -S gem list | grep log-courier',
  } ->

  file { '/opt/logstash/lib/logstash/inputs/courier.rb':
    source => 'puppet:///modules/dc_logstash/log_courier/logstash/inputs/courier.rb',
  } ->

  file { '/opt/logstash/lib/logstash/outputs/courier.rb':
    source => 'puppet:///modules/dc_logstash/log_courier/logstash/outputs/courier.rb',
  } ->

  Service['logstash']

}

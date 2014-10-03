# Class: dc_logstash::courier
#
# Install the server side components of log-courier
#
class dc_logstash::courier {

  file { '/opt/logstash/lib/logstash/inputs/courier.rb':
    ensure  => file,
    owner   => 'logstash',
    group   => 'logstash',
    mode    => '0664',
    source  => 'puppet:///modules/dc_logstash/log_courier/logstash/inputs/courier.rb',
    require => [ File['/opt/logstash/log-courier-14.gem'], Package['logstash'] ],
    notify  => Service['logstash'],
  }

  file { '/opt/logstash/lib/logstash/outputs/courier.rb':
    ensure  => file,
    owner   => 'logstash',
    group   => 'logstash',
    mode    => '0664',
    source  => 'puppet:///modules/dc_logstash/log_courier/logstash/outputs/courier.rb',
    require => [ File['/opt/logstash/log-courier-14.gem'], Package['logstash'] ],
    notify  => Service['logstash'],
  }

  file { '/opt/logstash/log-courier-14.gem':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/dc_logstash/log_courier/log-courier-0.14.gem',
    require => Package['logstash'],
    notify  => Exec['install_log_courier_gem'],
  }

  exec { 'install_log_courier_gem':
    refreshonly => true,
    cwd         => '/opt/logstash',
    environment => 'GEM_HOME=vendor/bundle/jruby/1.9',
    command     => '/usr/bin/java -jar vendor/jar/jruby-complete-1.7.11.jar -S gem install /opt/logstash/log-courier-14.gem',
  }

}

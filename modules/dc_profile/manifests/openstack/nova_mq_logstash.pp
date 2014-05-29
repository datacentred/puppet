# Class: dc_profile::openstack::nova_mq_logstash
#
# Configures logstash for rabbitmq
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::nova_mq_logstash {

  dc_logstash::client::register { 'rabbitmq_log':
    logs => "/var/log/rabbitmq/rabbit@${::hostname}.log",
    type => 'rabbitmq_log',
  }

  dc_logstash::client::register { 'rabbitmq_sasl_log':
    logs => "/var/log/rabbitmq/rabbit@${::hostname}-sasl.log",
    type => 'rabbitmq_sasl_log',
  }

  dc_logstash::client::register { 'rabbitmq_startup_error':
    logs => '/var/log/rabbitmq/startup_err',
    type => 'rabbitmq_startup_error',
  }  
  
  dc_logstash::client::register { 'rabbitmq_startup_log':
    logs => '/var/log/rabbitmq/startup_log',
    type => 'rabbitmq_startup_log',
  }

  dc_logstash::client::register { 'rabbitmq_shutdown_error':
    logs => '/var/log/rabbitmq/shutdown_err',
    type => 'rabbitmq_shutdown_error',
  }

  dc_logstash::client::register { 'rabbitmq_shutdown_log':
    logs => '/var/log/rabbitmq/shutdown_log',
    type => 'rabbitmq_shutdown_log',
  }

}

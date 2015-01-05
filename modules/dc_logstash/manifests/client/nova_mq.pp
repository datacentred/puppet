# Class: dc_logstash::client::nova_mq
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
class dc_logstash::client::nova_mq {

  dc_logstash::client::register { 'rabbitmq_log':
    logs   => "/var/log/rabbitmq/rabbit@${::hostname}.log",
    fields => {
      'type'   => 'rabbitmq_log',
    }
  }

  dc_logstash::client::register { 'rabbitmq_sasl_log':
    logs   => "/var/log/rabbitmq/rabbit@${::hostname}-sasl.log",
    fields => {
      'type' => 'rabbitmq_sasl_log',
    }
  }

  dc_logstash::client::register { 'rabbitmq_startup_error':
    logs   => '/var/log/rabbitmq/startup_err',
    fields => {
      'type' => 'rabbitmq_startup_error',
    }
  }

  dc_logstash::client::register { 'rabbitmq_startup_log':
    logs   => '/var/log/rabbitmq/startup_log',
    fields => {
      'type' => 'rabbitmq_startup_log',
    }
  }

  dc_logstash::client::register { 'rabbitmq_shutdown_error':
    logs   => '/var/log/rabbitmq/shutdown_err',
    fields => {
      'type' => 'rabbitmq_shutdown_error',
    }
  }

  dc_logstash::client::register { 'rabbitmq_shutdown_log':
    logs   => '/var/log/rabbitmq/shutdown_log',
    fields => {
      'type' => 'rabbitmq_shutdown_log',
    }
  }

}

# Class: dc_logstash::client
#
# Install and configure log-courier client for logstash
#
class dc_logstash::client (
  $logstash_server    = $dc_logstash::params::logstash_server,
  $logcourier_version = $dc_logstash::params::logcourier_version,
  $logcourier_port    = $dc_logstash::params::logcourier_port,
  $logstash_beavertcp_port = $dc_logstash::params::logstash_beavertcp_port,
  $log_shipper        = $dc_logstash::params::log_shipper,
  $beaver_timeout = $dc_logstash::params::beaver_timeout,
  $logstash_api_version = $dc_logstash::params::logstash_api_version,
) inherits dc_logstash::params {

  case $log_shipper {

    'log-courier' : {
      class { 'dc_logstash::client::config::log_courier':
        logstash_server    => $logstash_server,
        logcourier_version => $logcourier_version,
        logcourier_port    => $logcourier_port,
      }
    }
    'beaver' : {
      class { 'dc_logstash::client::config::beaver':
        logstash_server         => $logstash_server,
        logstash_api_version    => $logstash_api_version,
        logstash_beavertcp_port => $logstash_beavertcp_port,
        beaver_timeout          => $beaver_timeout,
      }
    }
    default : {
      class { 'dc_logstash::client::config::log_courier':
        logstash_server    => $logstash_server,
        logcourier_version => $logcourier_version,
        logcourier_port    => $logcourier_port,
      }
    }

  }

}

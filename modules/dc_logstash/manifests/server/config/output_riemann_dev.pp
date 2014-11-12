# Class: dc_logstash::server::config::output_riemann_dev
#
# Server side configuration for development riemann output
#
class dc_logstash::server::config::output_riemann_dev inherits dc_logstash::server {

  logstash::configfile { 'output_riemann_dev':
    content => template('dc_logstash/server/output_riemann_dev.erb'),
    order   => '21',
  }

}

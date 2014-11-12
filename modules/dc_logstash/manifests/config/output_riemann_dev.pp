# Class: dc_logstash::config::output_riemann_dev
#
# Server side configuration for development riemann output
#
class dc_logstash::config::output_riemann_dev {

  include dc_logstash::params

  logstash::configfile { 'output_riemann_dev':
    content => template('dc_logstash/output_riemann_dev.erb'),
    order   => '21',
  }

}

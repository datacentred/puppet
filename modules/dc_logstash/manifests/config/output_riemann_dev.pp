# Class: dc_logstash::config::output_riemann_dev
#
# Server side configuration for development riemann output
#
class dc_logstash::config::output_riemann_dev {

  $riemann_dev_host = hiera(riemann_dev_host)

  logstash::configfile { 'output_riemann_dev':
    content => template('dc_logstash/output_riemann_dev.erb'),
    order   => '21',
  }

}

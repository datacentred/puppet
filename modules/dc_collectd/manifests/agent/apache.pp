# == Class: dc_collectd::agent::apache
#
class dc_collectd::agent::apache{

  include ::apache::mod::status
  include ::collectd::plugin::apache

}

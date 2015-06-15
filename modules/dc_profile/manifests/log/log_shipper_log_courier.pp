# == Class: dc_profile::log::log_shipper_log_courier
#
# Install log courier
#
class dc_profile::log::log_shipper_log_courier {

  include ::dc_logstash::client::config::log_courier
  include ::dc_icinga::hostgroup_log_courier

}


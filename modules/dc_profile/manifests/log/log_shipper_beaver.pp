# == Class: dc_profile::log::log_shipper_beaver
#
# Install the beaver
#
class dc_profile::log::log_shipper_beaver {

  include ::dc_logstash::client::config::beaver
  include ::dc_icinga::hostgroup_beaver

}

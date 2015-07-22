# == Class: dc_logstash::client
#
# Installs a logshipper and scans for a standard set of logs
#
# === Parameters
#
# [*provider*]
#   Which log shipper to install
#
class dc_logstash::client (
  $provider = 'log_courier',
) {

  include "::dc_logstash::client::config::${provider}"
  # TODO: Hack Hack!!!
  include "::dc_icinga::hostgroup_${provider}"

  include ::dc_logstash::client::apache
  include ::dc_logstash::client::ceilometer
  include ::dc_logstash::client::cinder
  include ::dc_logstash::client::horizon
  include ::dc_logstash::client::foreman
  include ::dc_logstash::client::foreman_proxy
  include ::dc_logstash::client::glance
  include ::dc_logstash::client::heat
  include ::dc_logstash::client::keystone
  include ::dc_logstash::client::libvirt
  include ::dc_logstash::client::mail
  include ::dc_logstash::client::mongodb
  include ::dc_logstash::client::mysql
  include ::dc_logstash::client::neutron
  include ::dc_logstash::client::nova_common
  include ::dc_logstash::client::nova_compute
  include ::dc_logstash::client::nova
  include ::dc_logstash::client::rabbitmq
  include ::dc_logstash::client::syslog

}

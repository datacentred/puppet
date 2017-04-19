# == Class: dc_icinga2::services
#
# Defines all icinga2 service templates
#
class dc_icinga2::services {

  include ::dc_icinga2::services::bmc
  include ::dc_icinga2::services::ceph
  include ::dc_icinga2::services::canary_routers
  #include ::dc_icinga2::services::conntrack
  include ::dc_icinga2::services::dhcp
  include ::dc_icinga2::services::disk
  include ::dc_icinga2::services::dns
  include ::dc_icinga2::services::elasticsearch
  include ::dc_icinga2::services::haproxy
  include ::dc_icinga2::services::icingaweb2
  include ::dc_icinga2::services::interface
  include ::dc_icinga2::services::iptables_rule
  include ::dc_icinga2::services::jenkins
  include ::dc_icinga2::services::load
  include ::dc_icinga2::services::log_courier
  include ::dc_icinga2::services::lsyncd
  include ::dc_icinga2::services::mailq
  include ::dc_icinga2::services::memcached
  include ::dc_icinga2::services::memory
  include ::dc_icinga2::services::mongodb
  include ::dc_icinga2::services::mtu
  include ::dc_icinga2::services::ntp
  include ::dc_icinga2::services::openstack
  include ::dc_icinga2::services::pdu
  include ::dc_icinga2::services::pgsql
  include ::dc_icinga2::services::pgsql_replication
  include ::dc_icinga2::services::procs
  include ::dc_icinga2::services::psu
  include ::dc_icinga2::services::puppetdb
  include ::dc_icinga2::services::puppetserver
  include ::dc_icinga2::services::rabbitmq
  include ::dc_icinga2::services::raid
  include ::dc_icinga2::services::routing_table
  include ::dc_icinga2::services::sas
  include ::dc_icinga2::services::sensors
  include ::dc_icinga2::services::smart
  include ::dc_icinga2::services::smart_proxy
  include ::dc_icinga2::services::ssh
  include ::dc_icinga2::services::ssl
  include ::dc_icinga2::services::telegraf
  include ::dc_icinga2::services::tftp
  include ::dc_icinga2::services::users

}

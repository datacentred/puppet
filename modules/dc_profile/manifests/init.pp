# Class: dc_profile
#
# Base image, all host receive these bits
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile {

  contain dc_profile::auth::admins
  contain dc_profile::auth::sudoers
  contain dc_profile::editors::vim
  contain dc_profile::log::rsyslog_client
  contain dc_profile::monitoring::icinga_client
  contain dc_profile::monitoring::nsca_client
  contain dc_profile::net::mail
  contain dc_profile::net::ntpgeneric
  contain dc_profile::net::ssh
  contain dc_profile::perf::collectd
  contain dc_profile::puppet::mcollective_host
  contain dc_profile::puppet::puppet
  contain dc_profile::util::external_facts

}

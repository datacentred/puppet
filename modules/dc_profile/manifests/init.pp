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

  contain dc_profile::editors::vim
  contain dc_profile::net::hosts
  contain dc_profile::net::ntpgeneric
  contain dc_profile::puppet::puppet
  contain dc_profile::util::external_facts
  contain dc_profile::util::timezone
  contain dc_profile::util::locale
  contain dc_profile::util::facter

  if $::is_vagrant == undef {
    contain dc_profile::auth::admins
    contain dc_profile::net::ssh
    contain dc_profile::auth::sudoers
    if $::environment == 'production' {
      contain dc_profile::puppet::mcollective_host
      contain dc_profile::perf::collectd::agent
      contain dc_profile::net::mail
      contain dc_profile::mon::icinga_client
      contain dc_profile::mon::nsca_client
      contain dc_profile::mon::lmsensors
      contain dc_profile::log::rsyslog_client
      contain dc_profile::log::logstash_forwarder
      contain dc_profile::log::logrotate
    }
  }
}

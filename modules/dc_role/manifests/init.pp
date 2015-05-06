# == Class: dc_role
#
# Generic role all specializations inherit
#
class dc_role {

  hiera_include('classes')

  ## Don't include these classes on vagrant instances
  unless $::is_vagrant {
    include dc_profile::auth::admins
    include dc_profile::net::ssh
    include dc_profile::net::hosts
    include dc_profile::perf::sysdig
    include dc_profile::util::mdadm
    include dc_profile::util::grub
    include dc_profile::net::ntp
    include dc_profile::net::lldp
    include dc_profile::hardware::bmc
    include dc_profile::hardware::board_support

    ## Only include these classes in production
    if $::environment == 'production' {
      include dc_profile::puppet::mcollective
      include dc_profile::perf::collectd::agent
      include dc_profile::net::mail
      include dc_profile::mon::nsca_client
      include dc_profile::mon::lmsensors
      include dc_profile::log::rsyslog_client
      include dc_profile::log::log_courier
      include dc_profile::log::logrotate
    }
  }


}

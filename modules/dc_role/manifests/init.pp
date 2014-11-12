class dc_role {

  ## Include these classes on all systems
  include dc_profile::apt::apt
  include dc_profile::apt::dpkg
  include dc_profile::apt::repos
  include dc_profile::auth::rootpw
  include dc_profile::auth::sudoers
  include dc_profile::editors::vim
  include dc_profile::mon::icinga_client
  include dc_profile::puppet::puppet
  include dc_profile::util::external_facts
  include dc_profile::util::timezone
  include dc_profile::util::locale
  include dc_profile::util::facter
  include dc_profile::util::motd

  ## Don't include these classes on vagrant instances
  unless $::is_vagrant {
    include dc_profile::auth::admins
    include dc_profile::net::ssh
    include dc_profile::net::hosts
    include dc_profile::util::firmware
    include dc_profile::util::grub
    include dc_profile::perf::sysdig
    include dc_profile::util::mdadm
    include dc_profile::net::ntpgeneric

    ## Only include these classes in production
    if $::environment == 'production' {
      include dc_profile::puppet::mcollective_host
      include dc_profile::perf::collectd::agent
      include dc_profile::net::mail
      include dc_profile::mon::nsca_client
      include dc_profile::mon::lmsensors
      include dc_profile::log::rsyslog_client
      include dc_profile::log::log_courier
      include dc_profile::log::logrotate
    }
  }

  ## Include classes dependant on hardware
  ## TODO: Refactor this into a 'hardware' profile
  if $::productname =~ /ProLiant BL/ {
    include dc_profile::hp::hpblade
  }

}

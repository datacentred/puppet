# Base profile every host gets
class dc_profile::base {

  include dc_profile::vim
  include dc_profile::admins
  include dc_profile::ntpgeneric
  include dc_profile::mail
  include dc_profile::baserepos
  include dc_profile::sudoers
  include dc_profile::rootpw
  include dc_profile::sshconfig
  include dc_profile::puppet
  include dc_profile::icinga_client
  include dc_profile::rsyslog_client
  include dc_profile::external_facts
  include dc_profile::nsca_client
  include dc_profile::mcollective_host
}

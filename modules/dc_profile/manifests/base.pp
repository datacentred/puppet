# Base profile every host gets
class dc_profile::base {

  contain dc_profile::vim
  contain dc_profile::admins
  contain dc_profile::ntpgeneric
  contain dc_profile::mail
  contain dc_profile::sudoers
  contain dc_profile::sshconfig
  contain dc_profile::puppet
  contain dc_profile::icinga_client
  contain dc_profile::rsyslog_client
  contain dc_profile::external_facts
  contain dc_profile::nsca_client
  contain dc_profile::mcollective_host

}

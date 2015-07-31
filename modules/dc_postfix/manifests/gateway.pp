# Class: dc_postfix
#
# Installs postfix as a mail gateway
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_postfix::gateway (
  $external_sysmail_address,
  $smarthostuser,
  $smarthostpass,
  $rate_limit_config_hash,
  $smarthost_config_hash,
  $restrictions_config_hash,
  $networks_config_hash,
  $top_level_domain,
){

  $internal_sysmail_address = $dc_postfix::internal_sysmail_address

  class { 'postfix':
    smtp_listen         => 'all',
    root_mail_recipient => $internal_sysmail_address,
    mastercf_source     => 'puppet:///modules/dc_postfix/master.cf'
  }

  contain dc_postfix::virtual
  contain dc_postfix::networks
  contain dc_postfix::gmailrelay
  contain dc_postfix::ratelimit
  contain dc_postfix::restrictions

  include dc_icinga::hostgroup_smtp
  include dc_icinga::hostgroup_postfix

}

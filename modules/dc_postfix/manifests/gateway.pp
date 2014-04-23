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
class dc_postfix::gateway {

  class { 'postfix':
    smtp_listen         => 'all',
    root_mail_recipient => hiera(sal01_internal_sysmail_address),
  }

  include augeas

  contain dc_postfix::users
  contain dc_postfix::virtual
  contain dc_postfix::networks
  contain dc_postfix::gmailrelay
  contain dc_postfix::ratelimit
  contain dc_postfix::restrictions
  contain dc_postfix::nrpe

  include dc_icinga::hostgroups
  realize Dc_external_facts::Fact['dc_hostgroup_smtp']
  realize Dc_external_facts::Fact['dc_hostgroup_postfix']

}

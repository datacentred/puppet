# Class: dc_postfix::nullclient
#
# Installs postfix as a null client
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_postfix::nullclient {

    class { 'postfix':
      relayhost           => $dc_postfix::relayhost,
      myorigin            => $::fqdn,
      root_mail_recipient => $dc_postfix::internal_sysmail_address,
      satellite           => true,
    }

    include dc_icinga::hostgroup_postfix
}

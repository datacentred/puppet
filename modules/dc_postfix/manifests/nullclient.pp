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

    include augeas

    class { 'postfix':
      relayhost           => $dc_postfix::primary_mail_server,
      myorigin            => $::fqdn,
      root_mail_recipient => $dc_postfix::sal01_internal_sysmail_address,
      satellite           => true,
    }

    include dc_icinga::hostgroup_postfix
}

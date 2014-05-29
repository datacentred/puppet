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
      relayhost           => hiera(primary_mail_server),
      myorigin            => $::fqdn,
      root_mail_recipient => hiera(sal01_internal_sysmail_address),
      satellite           => true,
    }

    contain dc_postfix::nrpe

    include dc_icinga::hostgroups
    realize External_facts::Fact['dc_hostgroup_postfix']
}

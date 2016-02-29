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

    # Manage the postfix user and add it to the puppet group
    # so that postfix can use the puppet certs
    user { 'postfix':
      ensure  => present,
      groups  => [ 'puppet' ],
      require => Package['postfix'],
    }

    include dc_postfix::client_sec
    include dc_icinga::hostgroup_postfix
}

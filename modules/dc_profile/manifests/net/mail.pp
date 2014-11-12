# Class: dc_profile::net::mail
#
# Installs the null mailer on each host
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::net::mail {

  include ::dc_postfix
  include ::dc_nrpe::postfix

  package { 'nullmailer':
    ensure => purged,
  }
}

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






  package { 'nullmailer':
    ensure => purged,
  }

  #  class {'nullmailer':
  #  adminaddr   => $sysmailaddress,
  #  remoterelay => $smarthost,
  #  remoteopts  => "--auth-login --ssl --port=465 --user=${smarthostuser} --pass=${smarthostpass}",
  #}

}

# == Class: dc_bmc::foreman
#
# Configures Foreman with data harvested from the system, creating DHCP and DNS records
#
class dc_bmc::foreman (
  $foreman_username,
  $foreman_password,
  $foreman_url,
  $bmc_expected_subnet,
  $bmc_username,
  $bmc_password,
) {

  case $::osfamily {
    'RedHat': {
      $_packages = 'rubygem-ipaddress'
    }
    'Debian': {
      $_packages = 'ruby-ipaddress'
    }
    default: {
      warning('Ruby package IPAddr not defined for your OS, things may not work')
    }
  }

  if versioncmp($::puppetversion, '4.0.0') >= 0 {
    $_foreman_ssl_ca = '/etc/puppetlabs/puppet/ssl/certs/ca.pem'
    $_foreman_ssl_cert = "/etc/puppetlabs/puppet/ssl/certs/${::fqdn}.pem"
    $_foreman_ssl_key = "/etc/puppetlabs/puppet/ssl/private_keys/${::fqdn}.pem"
  } else {
    $_foreman_ssl_ca = '/var/lib/puppet/ssl/certs/ca.pem'
    $_foreman_ssl_cert = "/var/lib/puppet/ssl/certs/${::fqdn}.pem"
    $_foreman_ssl_key = "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem"
  }

  ensure_packages($_packages)

  ipmi_foreman { $::fqdn:
    foreman_username    => $foreman_username,
    foreman_password    => $foreman_password,
    foreman_url         => $foreman_url,
    foreman_ssl_ca      => $_foreman_ssl_ca,
    foreman_ssl_cert    => $_foreman_ssl_cert,
    foreman_ssl_key     => $_foreman_ssl_key,
    bmc_expected_subnet => $bmc_expected_subnet,
    bmc_username        => $bmc_username,
    bmc_password        => $bmc_password,
  }

}

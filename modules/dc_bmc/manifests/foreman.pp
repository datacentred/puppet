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
  $foreman_ssl_ca = "${::ssldir}/certs/ca.pem",
  $foreman_ssl_cert = "${::ssldir}/certs/${::fqdn}.pem",
  $foreman_ssl_key = "${::ssldir}/private_keys/${::fqdn}.pem",
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

  ensure_packages($_packages)

  ipmi_foreman { $::fqdn:
    foreman_username    => $foreman_username,
    foreman_password    => $foreman_password,
    foreman_url         => $foreman_url,
    foreman_ssl_ca      => $foreman_ssl_ca,
    foreman_ssl_cert    => $foreman_ssl_cert,
    foreman_ssl_key     => $foreman_ssl_key,
    bmc_expected_subnet => $bmc_expected_subnet,
    bmc_username        => $bmc_username,
    bmc_password        => $bmc_password,
  }

}

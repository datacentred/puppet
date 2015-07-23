# Class: dc_foreman_proxy::params
#
# Foreman_proxy params class
#
# Parameters:
#
# Actions:
#
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_foreman_proxy::params (
  $use_dns,
  $use_dhcp,
  $use_bmc,
  $use_puppetca,
  $use_puppet,
  $dns_key,
  $omapi_key,
  $omapi_secret,
  $use_tftp,
  $trusted_hosts,
) {}

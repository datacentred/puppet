# Class: dc_foreman_proxy
#
# Foreman_proxy
#
# Parameters:
#
# Actions:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_foreman_proxy (
  $use_tftp     = $dc_foreman_proxy::params::use_tftp,
  $use_dns      = $dc_foreman_proxy::params::use_dns,
  $use_dhcp     = $dc_foreman_proxy::params::use_dhcp,
  $use_bmc      = $dc_foreman_proxy::params::use_bmc,
  $use_puppetca = $dc_foreman_proxy::params::use_puppetca,
  $use_puppet   = $dc_foreman_proxy::params::use_puppet,
  $dns_key      = $dc_foreman_proxy::params::dns_key,
  $omapi_key    = $dc_foreman_proxy::params::omapi_key,
  $omapi_secret = $dc_foreman_proxy::params::omapi_secret,
) inherits dc_foreman_proxy::params {

  contain dc_foreman_proxy::install
  contain dc_foreman_proxy::config
  contain dc_foreman_proxy::service

  Class['dc_foreman_proxy::install'] -> Class['dc_foreman_proxy::config'] -> Class['dc_foreman_proxy::service']

}

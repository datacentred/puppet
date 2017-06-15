# == Class: ::dc_netbox::security
#
# Netbox Firewall - IPtables
#

class dc_netbox::security (
  $rules = {},
) {
  create_resources('firewall', $rules)
}

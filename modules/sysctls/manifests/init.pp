# == Class sysctls
#
# Generates sysctl entries independant of a particular module
#
# === Parameters
#
# [*values*]
#   Hash of key value pairs to be added to sysctl.d
#
# === Usage
#
# In hiera
#
#   sysctls::values:
#     net.ipv4.ip_forward:
#       value: 1
#
class sysctls (
  $values,
) {

  $defaults = {
    ensure => present,
  }

  create_resources('sysctl', $values, $defaults)

}

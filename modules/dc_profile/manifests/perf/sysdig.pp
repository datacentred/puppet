# Class: dc_profile::perf::sysdig
#
# Installs sysdig
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::perf::sysdig {
  include ::sysdig
  contain sysdig
}

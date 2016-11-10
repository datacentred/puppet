# Class: dc_profile::util::conntrack
#
# Install conntrack userland bins 
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::util::conntrack {

  case $facts['os']['name'] {
    /^(Debian|Ubuntu)$/: { ensure_packages('conntrack') }
    default: { notify { 'Conntrack install not supported on this platform': } }
  }

}

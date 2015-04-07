# == Class: dc_profile::util::augeas
#
# Installs augeas module to support modification of config files
#
# === Notes
#
# A lot of various client side providers will require this package to
# be present, ergo it is critical that this be installed for testing
# random inter-profile dependencies or during early bring up
#
class dc_profile::util::augeas {

  include ::augeas

}

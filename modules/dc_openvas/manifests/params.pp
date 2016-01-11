# Class: dc_openvas::params
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_openvas::params (
  $gsa_listen_port,
  $gsa_listen_address = $::ipaddress,
  $gsa_user,
  $gsa_password,
  $scan_targets,
){

}



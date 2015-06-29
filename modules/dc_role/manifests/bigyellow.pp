# Class: dc_role::bigyellow
#
# Bit of a mish mash this server!
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::bigyellow {

  contain dc_profile::net::aptmirror
  contain dc_profile::util::wwwbackups
  contain dc_elasticsearch::elasticsearch_snapshot
  contain dc_elasticsearch::elasticsearch_pruning

}

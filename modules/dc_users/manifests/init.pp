# Class: dc_users
#
#   Class to instantiate users based on groupings defined
#   in hiera
#
# Parameters:
#
#   $title - name of the group to instantiate
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#   dc_users { 'admins': }
#   dc_users { 'operators': }
#
# [Remember: No empty lines between comments and class definition]
define dc_users {

  $group = hiera($title)
  $users = keys($group)
  dc_users::user_account { $users:
    hash => $group,
  }

}

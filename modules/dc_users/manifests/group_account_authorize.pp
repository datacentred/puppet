# Allow users from a group to access an account
#
# Sample Usage:
#
# Authorize all admins to ssh to simon's account... fool!
#   dc_users::group_account_authorize { 'admins@simon': }
#
define dc_users::group_account_authorize {

  # Format 'group@account'
  $array = split($title, '@')
  $group = $array[0]
  $acct = $array[1]

  # Get the group from hiera and determine the list of users
  $hash = hiera($group)
  $users = keys($hash)

  # Format the user list ready to go to the key autorization
  $users_at_account = regsubst($users, '(.*)', "\\1@${acct}")

  # And add the keys
  dc_users::ssh_authorized_key { $users_at_account:
    hash => $hash,
  }

}

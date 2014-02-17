# Add a user's ssh ley to a specific account
define dc_users::ssh_authorized_key (
  $hash = undef,
) {

  # Format 'user@account'
  $array = split($title, '@')
  $user = $array[0]
  $acct = $array[1]

  ssh_authorized_key { "dc_users::ssh_authorized_key ${title}":
    ensure => present,
    user   => $acct,
    type   => 'ssh-rsa',
    key    => $hash[$user]['sshkey'],
  }

}

# Class: dc_profile::auth::tally
#
# Enable pam tally to prevent brute forcing of local terminal
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::auth::tally {

    pam { 'Enable pam_tally2':
      ensure    => present,
      service   => 'login',
      type      => 'auth',
      control   => 'required',
      module    => 'pam_tally2.so',
      arguments => ['deny=4', 'even_deny_root', 'unlock_time=1200'],
      position  => 'after module pam_faildelay.so',
    }

}

# Class: dc_profile::auth::rootpw
#
# Disable the root password of the host
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::auth::rootpw {

  # ********************************************************************
  # IMPORTANT SECURITY INFORMATION
  # ********************************************************************
  # Bootstrapping staging requires password root login via SSH
  # if this fact is set then allow a relaxed configuration.  Once
  # bootstrapping is complete hosts configured like this will
  # converge to the default security settings.  Root login MUST
  # be via an in-memory one time password to minimise the risks
  # to an absolute minimum.
  # ********************************************************************

  if ! $::staging_bootstrap {
    user { 'root':
      password => '!',
    }
  }

}

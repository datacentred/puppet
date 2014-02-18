# Class: dc_profile::apt::virtualboxrepo
#
# Install the virtual box repositories
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::apt::virtualboxrepo {

  realize (Dc_repos::Repo['local_virtualbox_mirror'])

}

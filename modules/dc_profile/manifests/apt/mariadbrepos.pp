# Class:
#
# Install the mariadb repositories
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::apt::mariadbrepos {

  realize (Dc_repos::Repo['local_mariadb_mirror'])

}

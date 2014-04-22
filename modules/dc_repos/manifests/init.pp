# Class:
#
# Installs all the repositories we need
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_repos {

  $aptsource_defaults = {
    include_src => false,
  }
  create_resources(apt::source, hiera_hash(repo_list), $aptsource_defaults)

}

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
class dc_repos (
  $repos = {},
) {

  $aptsource_defaults = {
    include_src => false,
  }
  create_resources(apt::source, $repos, $aptsource_defaults)

}

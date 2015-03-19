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
  $defaults = {},
) {

  create_resources(apt::source, $repos, $defaults)

}

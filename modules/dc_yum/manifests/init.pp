# == Class: dc_yum
#
# Wrapper class for the yumrepo built-in type
#
class dc_yum (
  $repo,
) {

  create_resources('yumrepo', $repo)

}

# == Class: dc_apt
#
# Apt resource wrapper
#
class dc_apt (
  $pins = {},
) {

  create_resources('apt::pin', $pins)

}

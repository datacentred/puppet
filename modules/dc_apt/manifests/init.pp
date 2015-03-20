# == Class: dc_apt
#
# TEMPORARY wrapper around puppetlabs-apt while they stop being
# anuses
#
class dc_apt (
  $pins = {},
) {

  create_resources('apt::pin', $pins)

}

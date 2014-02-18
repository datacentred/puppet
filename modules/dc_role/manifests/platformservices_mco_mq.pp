# Class: dc_role::platformservices_mco_mq
#
# Message queue used by mcollective
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::platformservices_mco_mq {

  contain dc_profile::puppet::mcollective_mq

}

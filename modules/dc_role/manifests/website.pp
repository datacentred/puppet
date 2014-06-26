#
# Customer-facing website - www.datacentred.co.uk
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::website {

  include dc_profile::wordpress::database
  include dc_profile::wordpress::server
  include dc_profile::wordpress::php

}


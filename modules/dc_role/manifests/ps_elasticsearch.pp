# Class: dc_role::ps_elasticsearch
#
# Role for setting up elasticsearch to support platform services
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::ps_elasticsearch {

  contain dc_profile::net::elasticsearch

}

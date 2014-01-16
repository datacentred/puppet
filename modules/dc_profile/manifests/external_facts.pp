class dc_profile::external_facts {

  anchor { 'dc_profile::external_facts::first': } ->
  class { 'dc_external_facts::external_facts': } ->
  anchor { 'dc_profile::external_facts::last': }

}

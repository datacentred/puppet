#
class dc_profile::apt {

  class { '::apt':
    purge_sources_list   => true,
    purge_sources_list_d => true,
  }
  contain 'apt'

}

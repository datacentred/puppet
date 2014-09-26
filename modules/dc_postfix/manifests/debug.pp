# == Class: dc_postfix::debug
#
class dc_postfix::debug {

  postfix::config { 'debug_peer_list':
    value => hiera(smarthost),
  }
  postfix::config { 'debug_peer_level':
    value => '3',
  }

}

# == Class: dc_postfix::virtual
#
class dc_postfix::virtual {

  include ::dc_postfix::gateway

  postfix::hash { '/etc/postfix/valias':
    ensure    => present,
    map_owner => 'postfix',
    content   => template('dc_postfix/valias.erb')
  }

  postfix::config { 'virtual_alias_maps':
    value => 'hash:/etc/postfix/valias',
  }

}

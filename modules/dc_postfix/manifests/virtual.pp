# == Class: dc_postfix::virtual
#
class dc_postfix::virtual {

  postfix::hash { '/etc/postfix/valias':
    ensure    => present,
    map_owner => 'postfix',
    content   => "${dc_postfix::gateway::internal_sysmail_address} ${dc_postfix::gateway::external_sysmail_address}",
  }

  postfix::config { 'virtual_alias_maps':
    value => 'hash:/etc/postfix/valias',
  }

}

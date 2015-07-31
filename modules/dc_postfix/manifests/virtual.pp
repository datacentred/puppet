# == Class: dc_postfix::virtual
#
class dc_postfix::virtual {

  postfix::hash { '/etc/postfix/valias':
    ensure    => present,
    map_owner => 'postfix',
    content   => "/^sysmail@.*\.${dc_postfix::gateway::top_level_domain}$/ ${dc_postfix::gateway::external_sysmail_address}",
  }

  postfix::config { 'virtual_alias_maps':
    value => 'regexp:/etc/postfix/valias',
  }

}

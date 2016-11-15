# == Class: dc_postfix::virtual
#
class dc_postfix::virtual {

  include ::dc_postfix::gateway

  $alias_domains = $::dc_postfix::gateway::alias_domains
  $external_sysmail_address = $::dc_postfix::gateway::external_sysmail_address

  postfix::hash { '/etc/postfix/valias':
    ensure  => present,
    content => template('dc_postfix/valias.erb')
  }

  postfix::config { 'virtual_alias_maps':
    value => 'hash:/etc/postfix/valias',
  }

}

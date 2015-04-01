# == Class: dc_postfix::virtual
#
class dc_postfix::virtual {

  postfix::config { 'virtual_mailbox_domains':
    ensure =>  absent,
  }

  postfix::config { 'virtual_mailbox_base':
    ensure =>  absent,
  }

  postfix::config { 'virtual_minimum_uid':
    ensure => absent,
  }

  postfix::config { 'virtual_uid_maps':
    ensure => absent,
  }

  postfix::config { 'virtual_gid_maps':
    ensure => absent,
  }

  postfix::hash { '/etc/postfix/vmailbox':
    ensure    => absent,
  }

  postfix::hash { '/etc/postfix/valias':
    ensure    => present,
    map_owner => 'postfix',
    content   => "${dc_postfix::gateway::internal_sysmail_address} ${dc_postfix::gateway::external_sysmail_address}",
  }

  postfix::config { 'virtual_alias_maps':
    value => 'hash:/etc/postfix/valias',
  }

}

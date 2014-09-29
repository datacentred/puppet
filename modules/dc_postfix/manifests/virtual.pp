# == Class: dc_postfix::virtual
#
class dc_postfix::virtual {

  $virtual_uid = hiera(postfix_virtual_uid)
  $virtual_gid = hiera(postfix_virtual_gid)
  $sysmailsplit = split(hiera(sal01_internal_sysmail_address), '@')
  $sysmailuser = $sysmailsplit[0]
  $internal_sysmail_address = hiera(sal01_internal_sysmail_address)
  $external_sysmail_address = hiera(external_sysmail_address)

  postfix::config { 'virtual_mailbox_domains':
    value => $::domain,
  }
  postfix::config { 'virtual_mailbox_base':
    value => hiera(postfix_vmailbox_base),
  }
  postfix::config { 'virtual_minimum_uid':
    value => '100',
  }
  postfix::config { 'virtual_uid_maps':
    value => "static:${virtual_uid}",
  }
  postfix::config { 'virtual_gid_maps':
    value => "static:${virtual_gid}",
  }

  postfix::hash { '/etc/postfix/vmailbox':
    ensure    => present,
    map_owner => 'postfix',
    content   => "${internal_sysmail_address} ${::domain}/${sysmailuser}/",
  }
  postfix::config { 'virtual_mailbox_maps':
    value => 'hash:/etc/postfix/vmailbox',
  }

  postfix::hash { '/etc/postfix/valias':
    ensure    => present,
    map_owner => 'postfix',
    content   => "${internal_sysmail_address} ${internal_sysmail_address}, ${external_sysmail_address}",
  }
  postfix::config { 'virtual_alias_maps':
    value => 'hash:/etc/postfix/valias',
  }

}

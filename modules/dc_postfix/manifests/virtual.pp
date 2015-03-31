# == Class: dc_postfix::virtual
#
class dc_postfix::virtual {

  # Remove these from hiera as well
  $virtual_uid = hiera(postfix_virtual_uid)
  $virtual_gid = hiera(postfix_virtual_gid)
  $sysmailsplit = split(hiera(sal01_internal_sysmail_address), '@')
  $sysmailuser = $sysmailsplit[0]
  $internal_sysmail_address = hiera(sal01_internal_sysmail_address)
  $external_sysmail_address = hiera(external_sysmail_address)

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
    content   => "${internal_sysmail_address} ${external_sysmail_address}",
  }

  postfix::config { 'virtual_alias_maps':
    value => 'hash:/etc/postfix/valias',
  }

}

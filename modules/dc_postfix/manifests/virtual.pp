class dc_postfix::virtual {

  $virtual_uid = hiera(postfix_virtual_uid)
  $virtual_gid = hiera(postfix_virtual_gid)
  $sysmailsplit = split(hiera(sysmailaddress), '@')
  $sysmailuser = $sysmailsplit[0]
  $sysmailaddress = hiera(sysmailaddress)

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
        content   => "${sysmailaddress} ${::domain}/${sysmailuser}/",
  }
  postfix::config { 'virtual_mailbox_maps':
        value => 'hash:/etc/postfix/vmailbox',
  }

}

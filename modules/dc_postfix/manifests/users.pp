class dc_postfix::users {

  group { 'vmail':
    name => 'vmail',
    gid  => hiera(postfix_virtual_gid),
  }

  user { 'vmail':
    name => 'vmail',
    uid  => hiera(postfix_virtual_uid),
    gid  => hiera(postfix_virtual_gid),
  }

  file { '/var/mail/vdomains':
    ensure  => directory,
    require => [ User['vmail'], Group['vmail'] ],
    owner   => 'vmail',
    group   => 'vmail',
  }

}

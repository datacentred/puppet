class dc_profile::puppet_master {

  $xmpp_jid  = hiera(xmpp_jid)
  $xmpp_pass = hiera(xmpp_pass)
  $xmpp_room = hiera(xmpp_room)
  $xmpp_name = hiera(xmpp_name)

  class { '::dc_puppetmaster':
  }

}


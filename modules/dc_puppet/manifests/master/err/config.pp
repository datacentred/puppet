# Class: dc_puppet::master::err::config
#
# Errbot configuration
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::master::err::config {

  $xmpp_jid  = hiera(xmpp_jid)
  $xmpp_pass = hiera(xmpp_pass)
  $xmpp_room = hiera(xmpp_room)
  $xmpp_name = hiera(xmpp_name)

  file { '/var/log/err':
    ensure => directory,
    mode   => '0755',
  }

  file { '/var/lib/err':
    ensure => directory,
    mode   => '0755',
  }

  file { '/etc/err':
    ensure => directory,
    mode   => '0755',
  }

  file { '/etc/err/plugins':
    ensure => directory,
    mode   => '0755',
  }

  file { '/etc/err/config.py':
    ensure  => file,
    mode    => '0644',
    content => template('dc_puppet/master/err/config.py.erb'),
    require => File['/etc/err'],
  }

  file { '/etc/err/plugins/github.plug':
    ensure  => file,
    mode    => '0644',
    content => template('dc_puppet/master/err/github.plug.erb'),
    require => File['/etc/err/plugins'],
  }

  file { '/etc/err/plugins/github.py':
    ensure  => file,
    mode    => '0644',
    content => template('dc_puppet/master/err/github.py.erb'),
    require => File['/etc/err/plugins'],
  }

  file { '/etc/init.d/err':
    ensure  => file,
    mode    => '0744',
    content => template('dc_puppet/master/err/err.erb'),
  }

}


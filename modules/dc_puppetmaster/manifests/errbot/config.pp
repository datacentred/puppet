# comment
class dc_puppetmaster::errbot::config {

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

  # todo: unhack me
  #$xmpp_jid  = '48569_551776@chat.hipchat.com'
  #$xmpp_pass = 'marvin'
  #$xmpp_room = '48569_development@conf.hipchat.com'
  #$xmpp_name = 'Marvin Bot'

  file { '/etc/err/config.py':
    ensure  => file,
    mode    => '0644',
    content => template('dc_puppetmaster/config.py.erb'),
    require => File['/etc/err'],
  }

  file { '/etc/err/plugins/github.plug':
    ensure  => file,
    mode    => '0644',
    content => template('dc_puppetmaster/github.plug.erb'),
    require => File['/etc/err/plugins'],
  }

  file { '/etc/err/plugins/github.py':
    ensure  => file,
    mode    => '0644',
    content => template('dc_puppetmaster/github.py.erb'),
    require => File['/etc/err/plugins'],
  }

  file { '/etc/init.d/errbot':
    ensure  => file,
    mode    => '0744',
    content => template('dc_puppetmaster/errbot.erb'),
  }

}


# == Class: dc_confluence
#
# Extensions to the community module to configure confluence
#
class dc_confluence (
  $dbname,
  $dbuser,
  $dbpassword,
  $dbtype = 'postgresql',
  $dbhost = 'localhost',
  $dbport = 5781,
  $setupstep = 'complete',
  $licensemessage = undef,
  $buildnumber = 5781,
  $serverid = undef,
  $homedir = '/home/confluence',
  $user = 'confluence',
  $group = 'confluence'
) {

  include ::confluence

  validate_re($setupstep, ['^complete$', '^setupdata-start$'])
  validate_re($serverid, '^([0-9A-Z]{4}\-){3}[0-9A-Z]{4}$')
  validate_re($licensemessage, '^[a-zA-Z0-9\/+=-]{501}$')
  validate_integer($buildnumber)
  validate_integer($dbport)

  # Explicitly control the user and group until
  # https://github.com/voxpupuli/puppet-confluence/pull/93
  group { $group:
    ensure => present,
    system => true,
  }

  user { $user:
    ensure     => present,
    system     => true,
    gid        => $group,
    managehome => true,
    home       => $homedir,
    shell      => '/bin/true',
  }

  case $dbtype {
    'postgresql': {
      $dbdriver = 'org.postgresql.Driver'
      $dbprotocol = 'postgresql'
      $dbdialect = 'net.sf.hibernate.dialect.PostgreSQLDialect'
    }
    default: {
      fail('Unssuported database')
    }
  }

  Class['::confluence::install'] ->

  file { "${homedir}/confluence.cfg.xml":
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => '0664',  # Confluence will reset this to 664 regardless
    content => template('dc_confluence/confluence.cfg.xml.erb'),
  } ~>

  Class['::confluence::service']

}

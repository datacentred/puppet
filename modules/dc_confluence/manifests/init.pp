# == Class: dc_confluence
#
# Extensions to the community module to configure confluence
#
class dc_confluence (
  String $dbname,
  String $dbuser,
  String $dbpassword,
  Dc_confluence::Dbtype $dbtype = 'postgresql',
  String $dbhost = 'localhost',
  Integer $dbport = 5432,
  Dc_confluence::Setupstep $setupstep = 'complete',
  Optional[String] $licensemessage = undef,
  Integer $buildnumber = 5781,
  Dc_confluence::Serverid $serverid = undef,
  String $homedir = '/home/confluence',
  String $user = 'confluence',
  String $group = 'confluence'
) {

  include ::confluence

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

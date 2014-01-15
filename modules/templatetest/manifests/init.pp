class templatetest {

  file { '/tmp/templatetest':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    content => template('templatetest/template.erb'),
  }

}

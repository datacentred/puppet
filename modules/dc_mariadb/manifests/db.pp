define dc_mariadb::db ($user,$password){

  mysql::db { "${title}":
    user     => $user,
    password => $password,
    host     => 'localhost',
    grant    => ['ALL'],
  }

}

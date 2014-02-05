define dc_mariadb::db ($dbname,$user,$password){

  mysql::db { "$dbname":
    user      => $user,
    password  => $password,
  }

}

# comment me
define dc_mariadb::db (
  $user,
  $password,
  $host = 'localhost',
  $grant = ['ALL'],
) {

  mysql::db { $title:
    user     => $user,
    password => $password,
    host     => $host,
    grant    => $grant,
  }

}

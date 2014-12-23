# == Define: dc_postgresql::db
#
define dc_postgresql::db (
  $user,
  $password,
  $access_address = '127.0.0.1/32',
) {

  postgresql::server::db { $title:
    user      => $user,
    password  => $password,
    require   => Class['::dc_postgresql::install'],
  }

  postgresql::server::pg_hba_rule { "allow ${access_address} to access ${title}":
    description => "Open up ${title} for access from ${access_address}",
    type        => 'host',
    database    => $title,
    user        => $user,
    address     => $access_address,
    auth_method => 'md5',
  }

}

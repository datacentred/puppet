#
class dc_profile::pgbackupclient {

  Ssh_authorized_key <<| tag == 'barman' |>>

  if $::postgres_key {

    $key_elements = split($::postgres_key, ' ')

    @@ssh_authorized_key { "postgres_key_${::hostname}" :
      ensure  => present,
      type    => 'ssh-rsa',
      key     => $key_elements[1],
      user    => 'barman',
      options => "from=\"${::ipaddress}\"",
      tag     => postgres,
    }

  }

}

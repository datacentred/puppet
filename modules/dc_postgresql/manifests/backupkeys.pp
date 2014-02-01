# Class: dc_postgresql::backupkeys
#
# Key configuration for barman backups
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_postgresql::backupkeys {

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


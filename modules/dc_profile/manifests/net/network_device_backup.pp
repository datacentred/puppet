# Class: dc_profile::net::network_device_backup
#
# Used to build a backup host which network devices will scp configs too.
# The backup host will monitor the filesystem and trigger a git push to a separate repo for version control.
#
# Parameters:
#
# Actions:
#
# Requires:

# Sample Usage:
class dc_profile::net::network_device_backup {

    user { 'Junos Backup User':
        ensure         => present,
        name           => 'junos',
        home           => '/home/junos',
        managehome     => true,
        password       => '$6$OmomDUedirt2Sz$J95Pp0pjXRhxLjLeT6Hj3du1jS4OYNrJIzMX98cQijyXrIrvDHbvXJ7Gi/VeuSyTpU5NrZyNFQD.u5id34F1s.',
        shell          => '/bin/bash',
        system         => true,
        purge_ssh_keys => true,
    }

    file { '/home/junos/backups':
        ensure  => directory,
        owner   => 'junos',
        group   => 'junos',
        force   => true,
        require => User['Junos Backup User'],
    }

    ssh_authorized_key { 'junos@datacentred.co.uk':
        user => 'junos',
        type => 'ssh-rsa',
        key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDZIV98YFCbCTwB5VKahUsT0pmWuhp/posTRWaX98DNXRgdeLb0LoaINmZK1EtVWZFj9I7TRif3KOiZ2yvLmCiHaGYT5bQTfbaUbZ0fHEyNWymLHJ2tyjVyS9iTFqUBNieOs0WPmI+IIdEYpGIgUOF6xTfzh7fHGgSjfol5uwfWpG1VoWK11MtWQeYkQj4dSpnGJkeFrRZlIWrWZtOKxusr87Khxi7Vs8O4C+lOuFhjG8cTwpQ4OlWtVTPKnQ3zysrFYJhidqWskNrl7jnFr0LByhS2pI3Q6pVzLgVWHqqlVP+fJf+PTkR62jYnrwSeKMBZR1CaVodtokKk82ir8+Ot'
    }
}

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

    include ::firewall
    
    firewall { '001 accept all to lo interface':
        proto   => 'all',
        iniface => 'lo',
        action  => 'accept',
    }

    firewall { '002 Allow inbound SSH':
        source => '185.98.148.0/22',
        dport  => 22,
        proto  => tcp,
        action => accept,
    }

    firewall { '003 Allow inbound SSH':
        source => '85.199.236.48/29',
        dport  => 22,
        proto  => tcp,
        action => accept,
    }

    firewall { '004 Allow inbound SSH':
        source => '185.43.216.0/22',
        dport  => 22,
        proto  => tcp,
        action => accept,
    }

    firewall { '005 accept related established rules':
        proto  => 'all',
        state  => ['RELATED', 'ESTABLISHED'],
        action => 'accept',
    }

    firewallchain { 'INPUT:filter:IPv4':
        purge  => true,
        policy => drop,
    }

    user { 'Junos Backup User':
        ensure     => present,
        name       => 'junos',
        home       => '/home/junos',
        managehome => true,
        password   => '$6$OmomDUedirt2Sz$J95Pp0pjXRhxLjLeT6Hj3du1jS4OYNrJIzMX98cQijyXrIrvDHbvXJ7Gi/VeuSyTpU5NrZyNFQD.u5id34F1s.',
        shell      => '/bin/bash',
        system     => true,
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
        key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC0aA1ffZhxKHL90e+fuk+3iOM+kdxpOwGVM6g7giyDHJAc82vGOPyL97trw4izIg6a6neDIFtJBJmlWi42qZEImj5pO0s9/cr34HBoux8ZaIj2rAFZpyW/FqayshDePsLa75OSX92JJr4aTMCyjpRn8hIm0jGlRyj8yQqrTnVfj3I88MYfMmjZ7HHpQqWIu4omBpQ9jCnD+1Yl/xbcvtFMfXiuPJAKNqYDMikOhDbDGaAGaqa3ymbRNfen7yfSz8OgmKl6hRX80GL71Q5oGDWGTa2cRrXa9pyjknvB8LOh8JWr1KH9+fSQ2O4uop+r5GLjAYEwJKd30m85oF6p9MUd',
    }
}

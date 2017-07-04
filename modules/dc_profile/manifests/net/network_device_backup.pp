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

    firewall { '000 accept all to lo interface':
        proto   => 'all',
        iniface => 'lo',
        action  => 'accept',
    } ->
    firewall { '005 Allow inbound SSH':
        source => '185.98.148.0/22',
        dport  => 22,
        proto  => tcp,
        action => accept,
    } ->
    firewall { '010 Allow inbound SSH':
        source => '85.199.236.48/29',
        dport  => 22,
        proto  => tcp,
        action => accept,
    } ->
    firewall { '015 Allow inbound SSH':
        source => '185.43.216.0/22',
        dport  => 22,
        proto  => tcp,
        action => accept,
    } ->
    firewall { '016 Allow inbound SSH from MSPW':
        source => '185.8.133.16/32',
        dport  => 22,
        proto  => tcp,
        action => accept,
    }

    firewall { '020 accept related established rules':
        proto  => 'all',
        state  => ['RELATED', 'ESTABLISHED'],
        action => 'accept',
    } ->
    firewallchain { 'INPUT:filter:IPv4':
        purge  => true,
        ignore => [
            # ignore the fail2ban jump rule
            '-j f2b',
        ],
        policy => drop,
    }

    user { 'Junos Backup User':
        ensure     => present,
        name       => 'junos',
        home       => '/home/junos',
        managehome => true,
        password   => '$6$63391E4yISne2q$en8R8nWymvepuggBPjT4e8DFYufJ1LVNooEC5bpWCvjPkrhV.1qKeE708hnIM5/JD8P1rYK8vQi6ddU7.iIIs/',
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
        user    => 'junos',
        type    => 'ssh-rsa',
        key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC0aA1ffZhxKHL90e+fuk+3iOM+kdxpOwGVM6g7giyDHJAc82vGOPyL97trw4izIg6a6neDIFtJBJmlWi42qZEImj5pO0s9/cr34HBoux8ZaIj2rAFZpyW/FqayshDePsLa75OSX92JJr4aTMCyjpRn8hIm0jGlRyj8yQqrTnVfj3I88MYfMmjZ7HHpQqWIu4omBpQ9jCnD+1Yl/xbcvtFMfXiuPJAKNqYDMikOhDbDGaAGaqa3ymbRNfen7yfSz8OgmKl6hRX80GL71Q5oGDWGTa2cRrXa9pyjknvB8LOh8JWr1KH9+fSQ2O4uop+r5GLjAYEwJKd30m85oF6p9MUd', # lint:ignore:140chars
        require => User['Junos Backup User'],
    }

}

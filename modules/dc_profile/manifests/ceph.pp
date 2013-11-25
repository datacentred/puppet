class dc_profile::ceph {

  user { 'cephadmin':
    ensure     => 'present',
    comment    => 'Ceph user created by Puppet',
    managehome => true,
    shell      => '/bin/bash',
  }

  file { '/home/cephadmin/.ssh':
    ensure  => 'directory',
    require => User['cephadmin'],
    owner   => 'cephadmin',
    mode    => '0700',
  }

  file { '/etc/sudoers.d/ceph':
    mode   => '0440',
    owner  => root,
    group  => root,
    source => 'puppet:///modules/profile/ceph/sudoers.ceph'
    }

}

class dc_gdash::install {

  # Create our base GDash installation directory
  file { $dc_gdash::gdash_root:
    ensure  => directory,
    recurse => true,
  }

  # Packages necessary to clone the GDash repo and use Bundler
  package { ['ruby-dev', 
            'git', 
            'ruby-bundler', 
            ]:
    ensure => installed,
  }

  # Clone GDash repo from GitHub
  vcsrepo { 'gdash_github':
    ensure   => present,
    path     => $dc_gdash::gdash_root,
    provider => 'git',
    source   => 'https://github.com/ripienaar/gdash.git',
    require  => Package['git'],
  }
    
  # Install the various gems upon which GDash depends
  bundler::install { $dc_gdash::gdash_root:
    user       => root,
    group      => root,
    require    => [ Package['git'], Vcsrepo['gdash_github'] ],
  }

}

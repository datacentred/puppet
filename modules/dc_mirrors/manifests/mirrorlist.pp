class dc_mirrors::mirrorlist {

include dc_mirrors::virtual

  $ubuntu_mirror_url              = hiera(ubuntu_mirror_url)
  $ubuntumirrorscomponents        = ['main', 'restricted', 'universe', 'multiverse']
  $ubuntumirrorsdebinstcomponents = ['main/debian-installer', 'restricted/debian-installer', 'universe/debian-installer', 'multiverse/debian-installer']

  $ubuntumirrors = {
    'ubuntu_precise_mirror'          => { release   => 'precise',
                                         components => [$ubuntumirrorscomponents],
    },
    'ubuntu_precise_updates_mirror'  => { release   => 'precise-updates',
                                         components => [$ubuntumirrorscomponents],
    },
    'ubuntu_precise_security_mirror' => { release   => 'precise-security',
                                         components => [$ubuntumirrorscomponents],
    },
    'ubuntu_precise_backports_mirror'=> { release   => 'precise-backports',
                                         components => [$ubuntumirrorscomponents],
    },
    'ubuntu_precise_debinst_mirror'  => { release   => 'precise',
                                         components => [$ubuntumirrorsdebinstcomponents],
    },
  }

  $ubuntumirrorsdefaults = {
    mirrorurl  => "$ubuntu_mirror_url",
    tag        => basemirrors
  }

  create_resources("@dc_mirrors::virtual::mirror", $ubuntumirrors, $ubuntumirrorsdefaults)

  @dc_mirrors::virtual::mirror { 'puppetlabs_precise_mirror':
    mirrorurl  => 'http://apt.puppetlabs.com',
    release    => 'precise',
    components => ['main', 'dependencies'],
  }

  @dc_mirrors::virtual::mirror { 'cloudarchive_precise_grizzly_mirror':
    mirrorurl  => 'http://ubuntu-cloud.archive.canonical.com/ubuntu',
    release    => 'precise-updates',
    components => ['grizzly'],
  }

  @dc_mirrors::virtual::mirror { 'nullmailer_precise_mirror':
    mirrorurl  => 'http://ppa.launchpad.net/mikko-red-innovation/ppa/ubuntu',
    release    => 'precise',
    components => ['main'],
  }

  @dc_mirrors::virtual::mirror { 'virtualbox_precise_mirror':
    mirrorurl  => 'http://download.virtualbox.org/virtualbox/debian',
    release    => 'precise',
    components => ['main'],
  }

  @dc_mirrors::virtual::mirror { 'HP_blade_support_precise_mirror':
    mirrorurl  => 'http://downloads.linux.hp.com/SDR/downloads/MCP/ubuntu',
    release    => 'precise-current',
    components => ['non-free'],
  }

  @dc_mirrors::virtual::mirror { 'ceph_precise_dumpling_mirror':
    mirrorurl  => 'http://ceph.com/debian-dumpling',
    release    => 'precise',
    components => ['main'],
  }
}

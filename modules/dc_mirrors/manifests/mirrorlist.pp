#
class dc_mirrors::mirrorlist {

include dc_mirrors::virtual

  $ubuntu_mirror_url = hiera(ubuntu_mirror_url)
  $ubuntumirrorscomponents = [
    'main',
    'restricted',
    'universe',
    'multiverse',
  ]
  $ubuntumirrorsdebinstcomponents = [
    'main/debian-installer',
    'restricted/debian-installer',
    'universe/debian-installer',
    'multiverse/debian-installer',
  ]

  $ubuntumirrors = {
    'ubuntu_mirror' => {
      release    => 'precise',
      components => [$ubuntumirrorscomponents],
    },
    'ubuntu_updates_mirror' => {
      release    => 'precise-updates',
      components => [$ubuntumirrorscomponents],
    },
    'ubuntu_security_mirror' => {
      release    => 'precise-security',
      components => [$ubuntumirrorscomponents],
    },
    'ubuntu_backports_mirror'=> {
      release    => 'precise-backports',
      components => [$ubuntumirrorscomponents],
    },
    'ubuntu_debinst_mirror'  => {
      release    => 'precise',
      components => [$ubuntumirrorsdebinstcomponents],
    },
  }

  $ubuntumirrorsdefaults = {
    mirrorurl  => $ubuntu_mirror_url,
    tag        => basemirrors,
  }

  create_resources(
    '@dc_mirrors::virtual::mirror',
    $ubuntumirrors,
    $ubuntumirrorsdefaults
  )

  @dc_mirrors::virtual::mirror { 'puppetlabs_mirror':
    mirrorurl  => 'apt.puppetlabs.com',
    release    => 'precise',
    components => ['main', 'dependencies'],
  }

  @dc_mirrors::virtual::mirror { 'cloudarchive_mirror':
    mirrorurl  => 'ubuntu-cloud.archive.canonical.com/ubuntu',
    release    => 'precise-updates/grizzly',
    components => ['main'],
  }

  @dc_mirrors::virtual::mirror { 'nullmailer_mirror':
    mirrorurl  => 'ppa.launchpad.net/mikko-red-innovation/ppa/ubuntu',
    release    => 'precise',
    components => ['main'],
  }

  @dc_mirrors::virtual::mirror { 'virtualbox_mirror':
    mirrorurl  => 'download.virtualbox.org/virtualbox/debian',
    release    => 'precise',
    components => ['contrib'],
  }

  @dc_mirrors::virtual::mirror { 'foreman_mirror':
    mirrorurl  => 'deb.theforeman.org',
    release    => 'precise',
    components => ['stable'],
  }

  @dc_mirrors::virtual::mirror { 'rsyslog_mirror':
    mirrorurl  => 'ubuntu.adiscon.com/v7-stable',
    release    => 'precise',
    components => [ '' ],
  }

  @dc_mirrors::virtual::mirror { 'HP_blade_support_mirror':
    mirrorurl  => 'downloads.linux.hp.com/SDR/downloads/MCP/ubuntu',
    release    => 'precise/current',
    components => ['non-free'],
  }

  @dc_mirrors::virtual::mirror { 'ceph_dumpling_mirror':
    mirrorurl  => 'ceph.com/debian-dumpling',
    release    => 'precise',
    components => ['main'],
  }

  @dc_mirrors::virtual::mirror { 'postgresql_mirror':
    mirrorurl  => 'apt.postgresql.org/pub/repos/apt',
    release    => 'precise-pgdg',
    components => ['main'],
  }

}

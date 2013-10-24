class dc_mirrors::mirrorlist {

include dc_mirrors::virtual

  $ubuntu_mirror_url = hiera(ubuntu_mirror_url)

  #  @dc_mirrors::virtual::mirror { 'ubuntu_precise_mirror':
  # mirrorurl  => "$ubuntu_mirror_url",
  # release    => 'precise',
  # components => ['main', 'restricted', 'universe', 'multiverse'],
  # tag        => basemirrors
  #}

  $ubuntumirrors = {
    'ubuntu_precise_mirror'          => { release => 'precise',},
    'ubuntu_precise_security_mirror' => { release => 'precise-security',},
    'ubuntu_precise_updates_mirror'  => { release => 'precise-updates',},
  }

  $ubuntumirrorsdefaults = {
    mirrorurl  => "$ubuntu_mirror_url",
    components => ['main', 'restricted', 'universe', 'multiverse'],
    tag        => basemirrors
  }

  create_resources("@dc_mirrors::virtual::mirror", $ubuntumirrors, $defaults)

}

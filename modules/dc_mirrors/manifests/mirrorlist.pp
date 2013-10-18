class dc_mirrors::mirrorlist {

include dc_mirrors::virtual

  $ubuntu_mirror_url = hiera(ubuntu_mirror_url)

  @dc_mirrors::virtual::mirror { 'ubuntu_precise_mirror':
    mirrorurl  => "$ubuntu_mirror_url",
    release    => 'precise',
    components => 'main,restricted,universe,multiverse',
    tag        => basemirrors
  }

}

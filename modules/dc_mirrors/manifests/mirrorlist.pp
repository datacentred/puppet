class dc_mirrors::mirrorlist {

include dc_mirrors::virtual

  $ubuntu_mirror_url = hiera(ubuntu_mirror_url)

  @dc_mirrors::virtual::localmirror { 'ubuntu_precise_mirror':
    mirror     => "$ubuntu_mirror_url",
    release    => 'precise',
    components => 'main restricted universe multiverse',
    tag        => basemirrors
  }

}

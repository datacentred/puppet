class dc_profile::aptmirror {

  include dc_mirrors::mirrorlist
  include concat::setup

  class { 'apt_mirror': }

    Dc_mirrors::Virtual::Mirror <| tag == basemirrors |>

}


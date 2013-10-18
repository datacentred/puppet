class dc_profile::aptmirror {

  include dc_mirrors::mirrorlist

  class { 'apt_mirror': }

    Dc_mirrors::Virtual::Mirror <| tag == basemirrors |>

}


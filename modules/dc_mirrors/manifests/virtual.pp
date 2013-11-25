class dc_mirrors::virtual {

  define mirror ($mirrorurl,$os="",$release,$components) {

    apt_mirror::mirror { "$title":
      mirror     => "$mirrorurl",
      os         => "$os",
      release    => "$release",
      components => $components,
    }

  }

}

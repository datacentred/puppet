class dc_mirrors::virtual {

  define mirror ($location,$os="",$release,$components) {

    apt_mirror::mirror { "$title":
      location   => "$location",
      os         => "$os",
      release    => "$release",
      components => "$components",
    }

  }

}

class repos::virtual {

  define repo ($location,$release,$repos,$key='undef',$key_server='undef') {

    apt::source { "$title":
      location          => "$location",
      release           => "$release",
      repos             => "$repos",
      include_src       => false,
    }

# Apt module uses keyserver.ubuntu.com by default

    if ( $key != 'undef' ) {
      if ( $keyserver != 'undef' ){
        apt::key { "$title":
          key        => "$key",
          key_server => "$key_server",
        }
      }
      else {
        apt::key { "$title":
          key => "$key",
        }
      }
    }
  }
}

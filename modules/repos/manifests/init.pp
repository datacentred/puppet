class repos::virtual {
	
	define repo ($location,$release,$repos,$key="",$key_server="") {

		apt::source { "$title":
                	location          => "$location",
                	release           => "$release",
                	repos             => "$repos",
                	include_src       => false,
		}

# FIXME check for a supplied keyserver or use default

		if ( $key != "" ) {
			apt::key { "$title":
				key	   => "$key",
				key_server => "$key_server",
			}
		}
			
	}

}

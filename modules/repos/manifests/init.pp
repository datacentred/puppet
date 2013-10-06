class repos::virtual {
	
	define repo ($location,$release,$repos,$key="",$key_server="") {

		apt::source { "$title":
                	location          => "$location",
                	release           => "$release",
                	repos             => "$repos",
                	include_src       => false,
		}

		if ( $key != "" ) {
			if ( $keyserver != "" ){
				apt::key { "$title":
					key	   => "$key",
					key_server => "$key_server",
				}
			}
			else {
				apt::key { "$title":
					key	   => "$key",
				}
			}	
		}
	}
			

}

class repos::virtual {
	
	define repo ("$location","$release","$repos") {

		apt::source { "$title":
                	location          => "$location",
                	release           => "$release",
                	repos             => "$repos",
                	include_src       => false,
		}
	}

}



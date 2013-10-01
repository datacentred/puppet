# This is the class containing the list of unrealized virtual users, don't use this class directly.

class profile::userlist {

include users-virtual

	@users-virtual::localuser { "mattj":
		uid	=>  "1001",
		gid	=>  "devops",
		pass	=>  '$6$qplx30n1$UyzxF3zIRuAm8cNtHtFL5V59HuezXzE3FStG8ermMrTsrowW5ACk6lGsn4GU2y0qTCcq0m13CYPltAY9X8v3i1',
	}

	@users-virtual::localuser { "nick":
	}
}

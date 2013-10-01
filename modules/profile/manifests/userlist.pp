# This is the class containing the list of unrealized virtual users, don't use this class directly.

class profile::userlist {

include users-virtual

	@users-virtual::localuser { "mattj":
		uid	=>  "1001",
		gid	=>  "1000",
		pass	=>  '$6$qplx30n1$UyzxF3zIRuAm8cNtHtFL5V59HuezXzE3FStG8ermMrTsrowW5ACk6lGsn4GU2y0qTCcq0m13CYPltAY9X8v3i1',
	}

	@users-virtual::localuser { "nick":
		uid	=>  "1002",
		gid 	=>  "1000",
		pass	=>  '',
		sshkey	=>  'AAAAB3NzaC1yc2EAAAADAQABAAABAQDZ6MGX3NlmNNaLpTne6n9ZOxzpRJlT0pcBEXVl/S8iHvFdAyaoKsCRI+U5dAV6ONlpDBMqkUBalGf2LfssVIiFlGi7U2iOBG6q9T2XjwP7YCBlqguRkbTFXU4qDix/wBcGsgOG+wWq9OJhRdJRWG1mt7kZDBoBGrGrSjdmOlfP/CVfSUBCJTAhpneQ1gYjHLujS5Ee+sIBU8k7pgAzUYaGpmOYbqW80+hmYB7EwsBiI+wfz21ki1UfWI5gjB0No2BKVgiXWPj0+zcFiNjVguTj/KrrsVXpKsJDqc/8tEgHIU1qBSdKFVjEu93QlxLinLg7zWyujlt/q+i5Gt+FlJal',
	}
}

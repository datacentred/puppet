# This is the class containing the list of unrealized virtual users, don't use this class directly.

class dc_users::userlist {

include dc_users::virtual

  @dc_users::virtual::account { 'matt':
    uid    => '1001',
    gid    => '1000',
    pass   => '$6$qplx30n1$UyzxF3zIRuAm8cNtHtFL5V59HuezXzE3FStG8ermMrTsrowW5ACk6lGsn4GU2y0qTCcq0m13CYPltAY9X8v3i1',
    sshkey => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCqHgq7htvOfOyNkZ8i505A6bEib9FiMNZGejce63jwo3SboRc1v25KQiXdRkuMIhLNZCgKM7aSErIZoPQoNxxHO1qvGsuOT3yld0jqXZHYp7L8To75y5gDp911N8enKVC3GMduPeXA8HH7RhNlPd6fUWmgmp4tBbd1iKnIZZDJ74P0mhKY47jbLV0SyvBli62WcqjKLH6DIgYPx73w31zti+HJCpPpUhzx19saJM2LbwGZ6HUL8FegXhIgcsV9vsB67tGZO/c2KFl+fRQgpYUTi6/17A19KbQP1GvYSiKb2uNhvYxwnU4D7zSZtlN7oXXiZ0xeI9MEExT24xd+sMmV',
  }

  @dc_users::virtual::account { 'nick':
    uid    => '1002',
    gid    => '1000',
    pass   => '$6$NPL/Pnap$nq67l3XdANH8HHY.z7C6CvJqTccDAE99yV2oxEx78gCdA1ofmTMIRvzfDG5FUZw80xz6eVMCoytzXO5L7Y/Ie/',
    sshkey => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDZ6MGX3NlmNNaLpTne6n9ZOxzpRJlT0pcBEXVl/S8iHvFdAyaoKsCRI+U5dAV6ONlpDBMqkUBalGf2LfssVIiFlGi7U2iOBG6q9T2XjwP7YCBlqguRkbTFXU4qDix/wBcGsgOG+wWq9OJhRdJRWG1mt7kZDBoBGrGrSjdmOlfP/CVfSUBCJTAhpneQ1gYjHLujS5Ee+sIBU8k7pgAzUYaGpmOYbqW80+hmYB7EwsBiI+wfz21ki1UfWI5gjB0No2BKVgiXWPj0+zcFiNjVguTj/KrrsVXpKsJDqc/8tEgHIU1qBSdKFVjEu93QlxLinLg7zWyujlt/q+i5Gt+FlJal',
  }

  @dc_users::virtual::account { 'dariush':
    uid    => '1003',
    gid    => '1000',
    pass   => '$6$g8y7.8wJ$FvZbW4XqG3JuL./jQt3QAt.IKG7WMQzTSWyP6TTtjC1EcYgdqxV/gjlsnC.muiJH3OAcX1zGtNRsO1vWZMWme1',
    sshkey => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQD1meqfHE5kqTp00XAqCFD3vqgRmYWTUK8FQ4Yt+VCKrtoUcjABsuk7tF3oqHdZaRCZAZaudW2bbqX3V3Sg45yoPgkBsC2StMSM8ZpsSdgBz9yqwCFctJCqqAjLJK9gSDT/iYAXzKgv5WTWtBb9b0sCfEgwPQBCGBh6ZJr6eqZF+cnADIVo7a6xJiOXV4uN8UozPLHNzrM4hnolfmVLAFHyTngfjicEQAXRP6z7S3c0wDmtqnvMg1lU+Gv+7Tit7jHE5yj0n3EJ1Z7dt4Nuj0i9Hv2SAVTvS8yMBMBKPb0EA/Ddj9tWY1ImEBZLILJPYAJusOUetR/NHDkLums405fZ',
  }
}

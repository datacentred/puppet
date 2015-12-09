#!/usr/bin/env python
"""
Check configured users are correct against puppet
Takes a space separated list
"""
import sys
import argparse
import pwd

def main():
    """
    Check users
    """
    parser = argparse.ArgumentParser()
    parser.add_argument('-u', '--users', nargs='+', required=True)
    args = parser.parse_args()

    incorrect_usernames = []
    incorrect_users = [u for u in pwd.getpwall()
                       if u.pw_uid > 1000 and not
                       u.pw_name == 'nobody' and
                       u.pw_name not in args.users]
    if len(incorrect_users) > 0:
        for user in incorrect_users:
            incorrect_usernames.append(user.pw_name)
        print "Incorrectly configured users found %s" % incorrect_usernames
        sys.exit(1)

    print "All users appear to be correct"
    sys.exit(0)

if __name__ == "__main__":
    main()



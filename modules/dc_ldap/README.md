# LDAP Admin Functions

This module adds puppet functions to administer LDAP directory entries.

## Specs

Run the specs from this subdirectory with `rake spec`. You'll have to run `bundle install` first.

## Functions

Each function returns a status code and message:

```ruby
code, message = ldap_add(...)
```

Zero indicates success.

### Add an entry to an LDAP directory.

```ruby
# Add an entry for the user with UID 'testy_test'.
ldap_add([host, port, admin_user, admin_password,
           {:dn => 'uid=testy_test,ou=People,dc=example,dc=net',
           :attributes => {
             :cn => 'Testy Tester', :givenName => 'Testy',
             :objectClass => ['top', 'person', 'inetorgPerson'],
             :sn => 'Tester', :mail => 'testy@test.com', 
             :uid => 'testy_test',
             :userPassword => '{SHA}6d3L1UCJtULYvBnp47aqAvjtfM8='}}])
```

Note: User passwords should be hashed with SHA1 as in the example.

### Modify an entry in an LDAP directory.

```ruby
# Add a mail for user with UID 'testy_test', set sn to blank, change givenName.
ldap_modify([host, port, admin_user, admin_password, 
            {:dn => 'uid=testy_test,ou=People,dc=example,dc=net',
            :operations => [
              [:add, :mail, "aliasaddress@example.com"],
              [:replace, :givenName, 'George'],
              [:delete, :sn]
            ]}])
```

### Remove an entry in an LDAP directory.

```ruby
# Remove entry for UID 'testy_test'.
ldap_remove(host, port, admin_user, admin_password,
  :dn => 'uid=testy_test,ou=People,dc=example,dc=net')
```

### Search for an entry in an LDAP directory.

```ruby
# Search in the example.net base for a mail with 'a*.com' matching.
ldap_search([host, port, admin_user, admin_password, 
           {:base => 'dc=example, dc=net', :filter => ['mail', 'a*.com'],
           :attributes => ["mail", "cn", "sn", "objectclass"]}])
```

### Hash a password with SHA-1 Digest

```ruby
sha1digest(["secret"]) # => "{SHA}5en6G6MezRroT3XKqkdPOmY/BfQ="
```

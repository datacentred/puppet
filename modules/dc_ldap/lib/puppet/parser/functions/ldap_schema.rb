# dn: dc=datacentred,dc=co,dc=uk
# objectclass: dcObject
# objectclass: organization
# o: datacentred.co.uk
# dc: datacentred

# dn: ou=People,dc=datacentred,dc=co,dc=uk
# objectClass: organizationalUnit
# objectClass: top
# ou: People

# dn: uid=rob,ou=People,dc=datacentred,dc=co,dc=uk
# objectClass: top
# objectClass: person
# objectClass: inetorgPerson
# uid: rob
# givenName: Rob
# sn: Greenwood
# cn: Rob Greenwood
# mail: rob.greenwood@datacentred.co.uk
# userPassword: {SHA}6d3L1UCJtULYvBnp47aqAvjtfM8=


# ldapadd -x -D "cn=admin,dc=datacentred,dc=co,dc=uk" -w llama123 -f schema.ldiff
# ldapsearch -x -b "dc=datacentred,dc=co,dc=uk"
# ldapsearch -x -D "uid=rob,ou=People,dc=datacentred,dc=co,dc=uk" -b "dc=datacentred,dc=co,dc=uk" -W

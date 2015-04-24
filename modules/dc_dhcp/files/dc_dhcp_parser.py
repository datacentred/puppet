#!/usr/bin/python
"""
Module for parsing host data from dhcp leases
"""
class DhcpHostsParser(object):
    """
    Parser class based on pyparsing
    """

    def __init__(self, dhcp_filename):
        self.dhcp_filename = dhcp_filename
        self.hosts = ""
        self.host_def = self._setup()

    def _setup(self):
        """
        Define grammar for a DHCP host declaration
        """
        from pyparsing import Suppress, Combine, \
                Literal, Word, delimitedList, \
                OneOrMore, Optional, dblQuotedString, \
                hexnums, alphanums

        lbrace, rbrace, semi, equals, quote = [Suppress(x)
				for x in ['{', '}', ';', '=', '"']]
        period, colon = [Literal(x) for x in ['.', ':']]
        number = Word('01234567890')
        hexint = Word(hexnums, exact=2)
        dnschars = Word(alphanums + '-') # characters permissible in DNS names
        mac = Combine(hexint + (colon + hexint) * 5)("mac_address")
        next_server = Combine(hexint + (":" + hexint) * 3)
        ip_addr = Combine(number + period + number \
                + period + number + period + number)
        ips = delimitedList(ip_addr)("ip_addresses")
        hardware_ethernet = Literal('hardware') + Literal('ethernet') \
                + mac + semi
        lease_name = Combine(dnschars + Optional(OneOrMore(period + dnschars)))
        lease_type = Literal('dynamic') + semi
        fixed_address = Literal('fixed-address') + ips + semi
        ddns_hostname = Literal('ddns-hostname') + dnschars + semi
        ddns_domainname = Literal('ddns-domainname') + quote \
                + OneOrMore(dnschars + period) + dnschars + quote + semi
        supersede_server_filename = Literal('supersede') \
                + Literal('server.filename') \
                + equals + dblQuotedString + semi
        supersede_server_nextserver = Literal('supersede') \
                + Literal('server.next-server') \
                + equals + next_server + semi
        supersede_server_hostname = Literal('supersede') \
                + Literal('host-name') + equals + quote \
                + lease_name + quote + semi

        # Put the grammar together to define a host declaration
        host_def = (Literal('host') + lease_name("lease_name") + lbrace \
                + Optional(lease_type)("lease_type") + Optional(ddns_hostname) \
                + Optional(ddns_domainname) + Optional(hardware_ethernet) \
                + Optional(fixed_address) + Optional(supersede_server_filename)
                + Optional(supersede_server_nextserver) \
                        + Optional(supersede_server_hostname)("ss_host") \
                        + rbrace)
        return host_def

    def parse(self):
        """
        Parse the file
        """
        with open(self.dhcp_filename, "rb") as dhcpf:
            self.hosts = self.host_def.scanString("".join(dhcpf.readlines()))

    def get_hosts(self):
        """
        Get all the hosts
        """
        return self.hosts

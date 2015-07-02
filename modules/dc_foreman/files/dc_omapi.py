"""
DataCentred OMAPI wrapper module
Provides custom extensions to pypureomapi
and a wrapper method for lookups
Expects a config file in ini format eg.

[omapi]
omapi_port = 7911
omapi_key = some_key
omapi_secret = some_secret
dhcp_server = 127.0.0.1

Usage:
import dc_omapi
omapi_server = dc_omapi.OmapiWrapper()
lookup_result = omapi_server.omapi_lookup(key, lookup_type)

"""
import pypureomapi
import time
import struct
import sys
import ConfigParser

# Custom pypureomapi stuff

STATES = {
    1: "free",
    2: "active",
    3: "expired",
    4: "released",
    5: "abandoned",
    6: "reset",
    7: "backup",
    8: "reserved",
    9: "bootp",
}

class Lease(object):
    """
    Define a Lease object
    """
    def __init__(self, obj):
        self.mac = None
        for (k, val) in obj:
            if k == "ip-address":
                self.ip_addr = pypureomapi.unpack_ip(val)
            elif k == "state":
                self.state = STATES[struct.unpack("!I", val)[0]]
            elif k == "hardware-address":
                self.mac = pypureomapi.unpack_mac(val)
            elif k == "client-hostname":
                self.client_hostname = val
            elif k == "starts":
                self.starts = unpack_time(val)
            elif k == "ends":
                self.ends = unpack_time(val)
            elif k == "tstp":
                self.tstp = unpack_time(val)
            elif k == "tsfp":
                self.tsfp = unpack_time(val)
            elif k == "atsfp":
                self.atsfp = unpack_time(val)
            elif k == "cltt":
                self.cltt = unpack_time(val)

def unpack_time(t_obj):
    """
    Unpack time
    """
    return struct.unpack("!I", t_obj)[0]

def format_time(t_obj):
    """
    Format a time string
    """
    return time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(t_obj))

class Omapi(pypureomapi.Omapi):
    """
    Custom OMAPI methods
    """

    def lookup_lease_ip(self, ip_addr):
        """
        Lookup lease by IP
        """
        msg = pypureomapi.OmapiMessage.open(b"lease")
        msg.obj.append((b"ip-address", pypureomapi.pack_ip(ip_addr)))
        response = self.query_server(msg)
        if response.opcode != pypureomapi.OMAPI_OP_UPDATE:
            raise pypureomapi.OmapiErrorNotFound()
        return Lease(response.obj)

    def lookup_lease_mac(self, mac):
        """
        Lookup lease by MAC
        """
        msg = pypureomapi.OmapiMessage.open(b"lease")
        msg.obj.append((b"hardware-address", pypureomapi.pack_mac(mac)))
        response = self.query_server(msg)
        if response.opcode != pypureomapi.OMAPI_OP_UPDATE:
            raise pypureomapi.OmapiErrorNotFound()
        return Lease(response.obj)

    def lookup_host_mac(self, mac):
        """
        Lookup host by MAC
        """
        msg = pypureomapi.OmapiMessage.open("host")
        msg.obj.append(("hardware-address", pypureomapi.pack_mac(mac)))
        response = self.query_server(msg)
        if response.opcode != pypureomapi.OMAPI_OP_UPDATE:
            raise pypureomapi.OmapiErrorNotFound()
        try:
            return pypureomapi.unpack_ip(dict(response.obj)["ip-address"])
        except KeyError: # ip-address
            raise pypureomapi.OmapiErrorNotFound()

class OmapiWrapper(object):
    """
    OMAPI wrapper class
    """
    def __init__(self, configfile):
        try:
            parser = ConfigParser.SafeConfigParser()
            parser.read(configfile)
        except ConfigParser.ParsingError, err:
            print 'Could not parse config file:', err
            sys.exit(1)
        self.dhcp_server = parser.get('omapi', 'dhcp_server')
        self.omapi_key = parser.get('omapi', 'omapi_key')
        self.omapi_secret = parser.get('omapi', 'omapi_secret')
        self.omapi_port = int(parser.get('omapi', 'omapi_port'))

    def omapi_lookup(self, key, lookup_type):
        """
        Lookup objects via OMAPI
        """
        try:
            oma = Omapi(self.dhcp_server, self.omapi_port,
                        self.omapi_key, self.omapi_secret)
            if lookup_type == 'host':
                ret = oma.lookup_host_mac(key)
            elif lookup_type == 'lease':
                ret = oma.lookup_lease_mac(key)
            return ret
        except pypureomapi.OmapiErrorNotFound:
            raise
        except pypureomapi.OmapiError, err:
            print "an error occured: %r" % (err,)
            sys.exit(1)

    def add_host(self, ip_addr, mac, name):
        """
        Add host as Foreman does
	"""
        try:
            oma = pypureomapi.Omapi(self.dhcp_server, self.omapi_port,
                        self.omapi_key, self.omapi_secret)
            oma.add_host_supersede_name(ip_addr, mac, name)
        except pypureomapi.OmapiError, err:
            print "an error occured: %r" % (err,)
            sys.exit(1)

"""
DataCentred Foreman module
Expects a config file in ini format eg.

[foreman]
foreman_admin_user = some_user
foreman_admin_pw = some_password
foreman_api_baseurl = https://foreman-server/api/v2/
cert_path = a_cert
cacert_path = a_cacert
key_path = a_key

Usage:
import dc_foreman
foreman_server = dc_foreman.Foreman(configfile)
foreman_server.check_api_endpoint()

"""
import requests
import json
import sys
from base64 import b64encode
import ConfigParser
import warnings

class Foreman(object):
    """
    Foreman class
    """
    def __init__(self, configfile):
        try:
            parser = ConfigParser.SafeConfigParser()
            parser.read(configfile)
        except ConfigParser.ParsingError, err:
            print 'Could not parse config file:', err
            sys.exit(1)
        self.foreman_api_baseurl = parser.get('foreman', 'foreman_api_baseurl')
        foreman_admin_user = parser.get('foreman', 'foreman_admin_user')
        foreman_admin_pw = parser.get('foreman', 'foreman_admin_pw')
        cert_path = parser.get('foreman', 'cert_path')
        key_path = parser.get('foreman', 'key_path')
        cacert_path = parser.get('foreman', 'cacert_path')
        auth_encode = b64encode('%s:%s' % (foreman_admin_user,
                                    foreman_admin_pw)).decode("ascii")
        self.headers = {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Basic %s'
            % auth_encode}
        self.cacert = cacert_path
        self.certs = (cert_path, key_path)

        with warnings.catch_warnings():
            warnings.filterwarnings(
                    "ignore", message=".*InsecureRequestWarning.*")


    def get_from_api(self, api_url):
        """
        Get stuff from Foreman
        """
        url = self.foreman_api_baseurl + api_url + '?per_page=10000'
        try:
            req = requests.get(
                 url, verify=self.cacert,
                    headers=self.headers, cert=self.certs)
        except requests.exceptions.RequestException as err:
            print "Error - got %s" % err
            sys.exit(1)
        if req.status_code == 200:
            data = json.loads(req.text)
            if 'results' in data:
                return data['results']
            else:
                return data
        else:
            print "Unexpected return code %s" % req.status_code
            print req.text
            sys.exit(1)

   # Check Foreman API endpoint
    def check_api_endpoint(self):
        """
        Check the Foreman API endpoint is working
        """
        try:
            req = requests.get(self.foreman_api_baseurl, verify=self.cacert,
                    headers=self.headers, cert=self.certs)
        except requests.exceptions.RequestException as err:
            print "Connection Error - got %s" % err
            sys.exit(1)
        if req.status_code != 200:
            print "Connection Error - got %s" % req.status_code
            sys.exit(1)
        else:
            return True

    def load_interfaces(self):
        """
        Return a dictionary with all Foreman defined interfaces
        """
        ints = []
        for host in self.get_from_api('hosts'):
            # Load the main interface
            ints.append({
                'name':host['name'].encode("ascii"),
                'ip':host['ip'].encode("ascii"),
                'mac':host['mac'].encode("ascii"),
                'subnet_id':host['subnet_id'],
                'type':'main'
            })
          # Check for any additional interfaces
            for foreman_int in self.get_from_api(
                        'hosts/' + str(host['id']) + '/interfaces'):
                # Filter out bonds which are the main interface
                if foreman_int['managed'] == True and not \
                        any(d['mac'] == foreman_int['mac'] for d in ints):
                    int_fqdn = foreman_int['name'] + '.' \
                            + foreman_int['domain_name']
                    ints.append({
                        'name':int_fqdn.encode("ascii"),
                        'ip':foreman_int['ip'].encode("ascii"),
                        'mac':foreman_int['mac'].encode("ascii"),
                        'type':foreman_int['type'].encode("ascii"),
                        'subnet_id':foreman_int['subnet_id']
                    })
        return ints

    def get_subnet_proxies(self, subnet_id):
        """
        Return subnet proxies URL given a subnet_id
        """
        subnet_info = self.get_from_api('subnets/' + str(subnet_id))
        dhcp_proxy = subnet_info['dhcp']['url']
        dns_proxy = subnet_info['dns']['url']
        tftp_proxy = subnet_info['tftp']['url']
        return dhcp_proxy, dns_proxy, tftp_proxy
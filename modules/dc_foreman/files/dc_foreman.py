"""
DataCentred Foreman module
Expects a config file in ini format eg.

[foreman]
foreman_api_user = some_user
foreman_api_pw = some_password
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
import urlparse

def netloc_from_url(url):
    """
    Extract a netloc given a valid url
    If argument is not a url, just return it back
    """
    try:
        parse_result = urlparse.urlsplit(url)
        return parse_result.netloc.split(':')[0]
    except AttributeError:
        return url

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
        foreman_api_user = parser.get('foreman', 'foreman_api_user')
        foreman_api_pw = parser.get('foreman', 'foreman_api_pw')
        cert_path = parser.get('foreman', 'cert_path')
        key_path = parser.get('foreman', 'key_path')
        cacert_path = parser.get('foreman', 'cacert_path')
        auth_encode = b64encode('%s:%s' % (foreman_api_user,
                                           foreman_api_pw)).decode("ascii")
        self.headers = {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Basic %s' % auth_encode}
        self.cacert = cacert_path
        self.certs = (cert_path, key_path)

        with warnings.catch_warnings():
            warnings.filterwarnings("ignore",
                                    message=".*InsecureRequestWarning.*")

    def get_from_api(self, api_url):
        """
        Get stuff from Foreman
        """
        url = self.foreman_api_baseurl + api_url + '?per_page=10000'
        try:
            req = requests.get(url, verify=self.cacert,
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

    def put_to_api(self, api_url, payload):
        """
        Update stuff in Foreman
        """
        url = self.foreman_api_baseurl + api_url
        try:
            req = requests.put(url, verify=self.cacert,
                               data=json.dumps(payload),
                               headers=self.headers, cert=self.certs)
        except requests.exceptions.RequestException as err:
            print "Error - got %s" % err
            sys.exit(1)
        if req.status_code == 200:
            return
        else:
            print "Unexpected return code %s" % req.status_code
            print req.text
            sys.exit(1)

    def post_to_api(self, api_url, payload):
        """
        Create stuff in Foreman
        """
        url = self.foreman_api_baseurl + api_url
        try:
            req = requests.post(url, verify=self.cacert,
                                data=json.dumps(payload),
                                headers=self.headers, cert=self.certs)
        except requests.exceptions.RequestException as err:
            print "Error - got %s" % err
            sys.exit(1)
        if req.status_code == 200:
            return
        else:
            print "Unexpected return code %s" % req.status_code
            print req.text
            sys.exit(1)

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
        if req.status_code not in (403, 200):
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
            # exclude unmanaged hosts
            if host['managed'] == False:
                continue
	    # exclude cloud hosts
            if host['provision_method'] == 'image':
                continue
            # Load the main interface
            ints.append({
                'name':host['name'].encode("ascii"),
                'ip':host['ip'].encode("ascii"),
                'mac':host['mac'].encode("ascii"),
                'subnet_id':host['subnet_id'],
                'host_id':host['id'],
                'type':'main'
            })
          # Check for any additional interfaces
            for foreman_int in self.get_from_api('hosts/' +
                                                 str(host['id']) +
                                                 '/interfaces'):
                # Filter out bonds which are the main interface
                if foreman_int['managed'] == True and \
                        foreman_int['ip'] != None and not \
                        any(d['mac'] == foreman_int['mac'] for d in ints):
                    ints.append({
                        'name':foreman_int['name'].encode("ascii"),
                        'ip':foreman_int['ip'].encode("ascii"),
                        'mac':foreman_int['mac'].encode("ascii"),
                        'type':foreman_int['type'].encode("ascii"),
                        'subnet_id':foreman_int['subnet_id'],
                        'host_id':host['id']
                    })
        return ints

    def get_host_id(self, fqdn):
        """
        Get host id
        """
        host = self.get_from_api('hosts/' + fqdn)
        return host['id']

    def get_subnet_proxies(self, subnet_id):
        """
        Return subnet proxies URL given a subnet_id
        """
        subnet_info = self.get_from_api('subnets/' + str(subnet_id))
        dhcp_proxy = subnet_info['dhcp']['url']
        dns_proxy = subnet_info['dns']['url']
        tftp_proxy = subnet_info['tftp']['url']
        return dhcp_proxy, dns_proxy, tftp_proxy

    def find_domain(self, subnet_id):
        """
        Find which domain a subnet belongs to
        """
        for domain in  self.get_from_api('domains'):
            for subnet in self.get_from_api('domains' + '/'
                                            + str(domain['id']))['subnets']:
                if subnet['id'] == subnet_id:
                    return domain['id'], domain['name']
                else:
                    continue
        print "Could not find domain for subnet_id %s" % subnet_id
        sys.exit(1)

    def find_subnet_info(self, subnet):
        """
        Return network info and domain for a subnet
        """
        subnet_info = [network for network in self.get_from_api('subnets')
                       if network['network'] == subnet][0]
        domain = self.find_domain(subnet_info['id'])
        return subnet_info, domain

    def get_all_subnet_proxies(self):
        """
        Return a list of dictionaries with proxies for all subnets
        """
        proxy_list = []
        dynamic_subnets = [subnet for subnet in self.get_from_api('subnets/')
                           if subnet['boot_mode'] != "Static"]
        for subnet in dynamic_subnets:
	    # Handle non-provisioning managed networks
	    # Foreman returns this as None, so normalize the url field
            if subnet['tftp'] == None:
                subnet['tftp'] = {'url':None}
	    # Extract the netloc from the URL and add to the dictionary
            proxy_list.append({
                'subnet_id':subnet['id'],
                'dns_proxy':{'url': subnet['dns']['url'],
                             'netloc': netloc_from_url(subnet['dns']['url'])},
                'tftp_proxy':{'url': subnet['tftp']['url'],
                              'netloc': netloc_from_url(subnet['tftp']['url'])},
                'dhcp_proxy':{'url': subnet['dhcp']['url'],
                              'netloc': netloc_from_url(subnet['dhcp']['url'])},
                })
        return proxy_list

    def get_host_info(self, host_id):
        """
        Return info about a host
        """
        host_info = self.get_from_api('hosts/' + str(host_id))
        return host_info

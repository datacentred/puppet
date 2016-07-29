# Puppet provider to manage BMC networking
#
require 'ipaddr'
require 'json'
require 'net/http'
require 'openssl'

Puppet::Type.type(:ipmi_foreman).provide(:foreman_api) do

  def initialize(value={})
    super(value)
    @update = false
  end

  # Load and cache the SSL resources for HTTPS requests
  def cache_resources
    @store = OpenSSL::X509::Store.new
    begin
      ca = File.read(resource[:foreman_ssl_ca])
      @store.add_cert(OpenSSL::X509::Certificate.new(ca))
    rescue Errno::ENOENT
      raise Puppet::Error.new("Unable to CA certificate \"#{resource[:foreman_ssl_ca]}\"")
    rescue OpenSSL::X509::CertificateError
      raise Puppet::Error.new("Unable to import CA certificate \"#{resource[:foreman_ssl_ca]}\"")
    end

    begin
      cert = File.read(resource[:foreman_ssl_cert])
      @cert = OpenSSL::X509::Certificate.new(cert)
    rescue Errno::ENOENT
      raise Puppet::Error.new("Unable to access client certificate \"#{resource[:foreman_ssl_cert]}\"")
    rescue OpenSSL::X509::CertificateError
      raise Puppet::Error.new("Unable to import client certificate \"#{resource[:foreman_ssl_cert]}\"")
    end

    begin
      key = File.read(resource[:foreman_ssl_key])
      @key = OpenSSL::PKey::RSA.new(key)
    rescue Errno::ENOENT
      raise Puppet::Error.new("Unable to access client key \"#{resource[:foreman_ssl_key]}\"")
    rescue OpenSSL::PKey::RSAError
      raise Puppet::Error.new("Unable to import client key \"#{resource[:foreman_ssl_key]}\"")
    end
  end

  # Use the Foreman API
  def foreman(method, path, payload = nil)
    uri = URI("https://#{resource[:foreman_url]}#{path}")

    # Set up the SSL session
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.cert_store = @store
    http.cert = @cert
    http.key = @key

    # Create the correct request method
    case method
    when 'GET'
      req = Net::HTTP::Get.new(uri)
    when 'POST'
      req = Net::HTTP::Post.new(uri)
      req.body = JSON.generate(payload)
      req['Content-Type'] = 'application/json'
    when 'PUT'
      req = Net::HTTP::Put.new(uri)
      req.body = JSON.generate(payload)
      req['Content-Type'] = 'application/json'
    end
    req.basic_auth(resource[:foreman_username], resource[:foreman_password])

    # Try perform a request, catch all socket and SSL errors
    begin
      response = http.request(req)
    rescue SocketError
      raise Puppet::Error.new("Unable to connect to Foreman URL \"#{resource[:foreman_url]}\"")
    rescue OpenSSL::SSL::SSLError => ex
      raise Puppet::Error.new("Unable to complete SSL handshake with peer \"#{resource[:foreman_url]}\": #{ex}")
    end

    # Try parse the output, should always be in JSON
    begin
      body = JSON.parse(response.body)
    rescue JSON::ParserError
      raise Puppet::Error.new("Request to \"#{uri}\" returned invalid JSON")
    end

    # Finally check for errors on the server side
    if response.code != '200'
      msg = body['error'] && body['error']['message'] || 'Unable to grok response'
      raise Puppet::Error.new("Request to \"#{uri}\" failed: #{msg}")
    end

    body
  end

  def exists?
    # First call to the class cache the SSL resources
    cache_resources

    # Search for an existing IPMI interface
    resp = foreman('GET', "/api/hosts/#{resource[:name]}/interfaces")
    @ipmi = resp['results'].detect{ |x| x['type'] == 'bmc' }
  end

  # Scan each IPMI channel for the LAN channel
  def get_ipmi_lan_channel
    # 0 = IPMB, 1-11 = Application Specific, 12-13 = Reserved, 14 = Current, 15 = System
    (1..11).each do |channel|
      begin
        output = %x{ipmitool channel info #{channel} 2> /dev/null}
      rescue Errno::ENOENT
        raise Puppet::Error.new('ipmitool is not installed')
      end
      next unless $? == 0
      return channel if /LAN/.match(output)
    end
    raise Puppet::Error.new('Unable to detect IPMI LAN Channel')
  end

  # Extract the specified field
  def get_ipmi_field(channel, match)
    ouput = %x{ipmitool lan print #{channel}}.split("\n")
    line = ouput.detect{ |x| x.start_with?(match) }
    value = line.split(':', 2)[1].strip
    value.empty? && nil || value
  end

  # Extract the IP address from the LAN channel
  def get_ipmi_address(channel)
    # Extra space differentiates from 'IP Address Source'
    address = get_ipmi_field(channel, 'IP Address  ')
    address or raise Puppet::Error.new("Unable to get IPMI IP address")
  end

  # Extract the MAC address from the LAN channel
  def get_ipmi_mac_address(channel)
    mac = get_ipmi_field(channel, 'MAC Address')
    mac or raise Puppet::Error.new("Unable to get IPMI MAC address")
  end

  # Given the IP address determine the subnet from the server
  def get_subnet(address)
    addr = IPAddr.new(address)
    subnets = foreman('GET', '/api/subnets')
    subnet = subnets && subnets['results'] && subnets['results'].detect{ |x| IPAddr.new(x['network_address']).include?(addr) }
    subnet or raise Puppet::Error.new("Unable to locate subnet for address \"#{address}\"")
  end

  # Given the subnet determine the domain it belongs to
  def get_domain(subnet)
    domains = foreman('GET', "/api/subnets/#{subnet['id']}/domains")
    domain = domains && domains['results'] && domains['results'].first
    domain or raise Puppet::Error.new("Unable to locate domain for subnet \"#{subnet['name']}\"")
  end

  # Given the FQDN get the hostname
  def get_host(fqdn)
    foreman('GET', "/api/hosts/#{fqdn}")
  end

  def create
    # Extract IPMI data from the local machine
    channel = get_ipmi_lan_channel
    address = get_ipmi_address(channel)
    mac = get_ipmi_mac_address(channel)

    # Check the switch is configured correctly and on the right VLAN
    raise Puppet::Error.new("Address \"#{address}\" not in expected subnet \"#{}\"") unless IPAddr.new(resource[:bmc_expected_subnet]).include?(IPAddr.new(address))

    # Extract mappings from Foreman
    subnet = get_subnet(address)
    domain = get_domain(subnet)
    host = get_host(resource[:name])

    payload = {
      'interface' => {
        'identifier' => 'ipmi',
        'type'       => 'bmc',
        'managed'    => 'true',
        'name'       => resource[:name].split('.')[0] + '-bmc',
        'ip'         => address,
        'mac'        => mac,
        'username'   => resource[:bmc_username],
        'password'   => resource[:bmc_password],
        'provider'   => 'IPMI',
        'domain_id'  => domain['id'],
        'subnet_id'  => subnet['id'],
        'host_id'    => host['id'],
      },
    }

    # If ipmi is not nil, then we are updating an existing record
    if @ipmi
      foreman('PUT', "/api/hosts/#{resource[:name]}/interfaces/#{@ipmi['id']}", payload)
    else
      foreman('POST', "/api/hosts/#{resource[:name]}/interfaces", payload)
    end
  end

  def flush
    create
  end

  def bmc_username
    @ipmi['username']
  end

  def bmc_username=(value)
  end

  def bmc_password
    @ipmi['password']
  end

  def bmc_password=(value)
  end

end

Puppet::Type.type(:ipmi_network).provide(:http_ipmi_network) do

desc "Support for Network configuration on the IPMI interface."

  require 'net/http'

  public

  def initialize(value={})
    super(value)
    @network_keys = [
      'HostName',
      'ChannelNum',
      'IPAddrSource',
      'EnableVLAN',
      'VLANTag',
      'IP',          
      'Mask',
      'Gateway',
      'PrimaryDNS',
      'SecondaryDNS',
      'DomainName'
    ]
    @network_payload = {}
    @login_payload = {}
  end

  def exists?
    @cookie ||= login
    get_network_cfg
    true
  end

  def create
    Puppet.debug("CREATING NEW RESOURCE")
    set_network_cfg
  end

  def destroy
    Puppet.info("This module does not support disabling IPMI networking")
  end
  
  # Getters and setters come here
  def ipaddress
    @network_payload['IP']
  end

  def ipaddress=(ipaddress)
    @network_payload['IP'] = ipaddress
  end

  def subnet_mask
    @network_payload['Mask']
  end

  def subnet_mask=(subnet_mask)
    @network_payload['Mask'] =  subnet_mask
  end

  def hostname
    @network_payload['HostName']
  end

  def hostname=(hostname)
    @network_payload['HostName'] = hostname
  end

  def default_gateway
    @network_payload['Gateway']
  end

  def default_gateway=(default_gateway)
    @network_payload['Gateway'] = default_gateway
  end

  def primary_dns_server
    @network_payload['PrimaryDNS']
  end

  def primary_dns_server=(primary_dns_server)
    @network_payload['PrimaryDNS'] = primary_dns_server
  end

  def secondary_dns_server
    @network_payload['SecondaryDNS']
  end

  def secondary_dns_server=(secondary_dns_server)
    @network_payload['SecondaryDNS'] = secondary_dns_server
  end

  def vlan_tag
    @network_payload['VLANTag']
  end

  def vlan_tag=(vlan_tag)
    @network_payload['VLANTag'] = vlan_tag
  end

  def domain_name
    @network_payload['DomainName']
  end

  def domain_name=(domain_name)
    @network_payload['DomainName'] = domain_name
  end

  def flush
    set_network_cfg
  end

  private

  NETWORK_SET_URI   = '/rpc/setnwconfig.asp'
  NETWORK_GET_URI   = '/rpc/getnwconfig.asp'
  LOGIN_URI         = '/rpc/WEBSES/create.asp'

  def set_network_cfg

    if @resource[:enable_vlan] == true
      @network_payload['EnableVLAN'] = 1
    else
      @network_payload['EnableVLAN'] = 0
    end

    if @resource[:dhcp] == true
      @network_payload['IPAddrSource'] = 2
    else
      @network_payload['IPAddrSource'] = 1
    end

    @network_payload['ChannelNum'] = @resource[:channel]

    response, status = ipmi_request(NETWORK_SET_URI, "POST", @network_payload)
    if status != '200'
      raise "IPMI server error: #{status}."
    end
  end

  def get_network_cfg

    response, status = ipmi_request(NETWORK_GET_URI, "GET")
    if status != '200'
      raise "IPMI server error: #{status}."
    end
    for key in @network_keys
      if @network_payload[key] == nil
        if key == 'EnableVLAN'
          @network_payload[key] = parse_response_for('VlanEnable', response.body)
        elsif key == 'VLANTag'
          @network_payload[key] = parse_response_for('VLANID', response.body)
        elsif key != 'ChannelNum'
          @network_payload[key] = parse_response_for(key, response.body)
        end
      end
    end
  end

  def login 

    @login_payload['WEBVAR_USERNAME'] = @resource[:username]
    @login_payload['WEBVAR_PASSWORD'] = @resource[:password]

    response, status =  ipmi_request(LOGIN_URI, "POST", 
                                     @login_payload, setcookie=false)
    if status == '200' && check_response_code(response.body) == '0'
      cookie = parse_response_for('SESSION_COOKIE', response.body)
      if cookie == nil
        raise "Server didn't return a valid cookie after login."
      end
    else
      raise "IPMI server error: #{status}."
    end
    cookie
  end

  def parse_response_for(key, text)
    
    match = /'#{key}'\s*:\s*(')?([\w\:\.\-]*)(')?/.match(text)
    if match != nil
      match[2]
    else 
      return nil
    end
  end

  def check_response_code(resp)

      match = /HAPI_STATUS:(\w+)/.match(resp)
      if match != nil
        match[1]
      else
        return nil
      end
  end

  def ipmi_request(uri, type, payload=[], setcookie=true)

    url = "http://#{@resource[:name]}#{uri}"

    if type == 'POST'
      request = Net::HTTP::Post.new(url)
      payload = URI.encode_www_form(payload)
    else
      request = Net::HTTP::Get.new(url)
    end

    request.add_field('content-type', 'application/x-www-form-urlencoded')

    if setcookie == true
      request.add_field('Cookie', "SessionCookie=#{@cookie}")
    end

    if type == 'POST'
      request.body = payload
    end

    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.request(request)
    status = response.code
    Puppet.debug(response.body)
    return response, status
  end

end

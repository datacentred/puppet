Puppet::Type.type(:ipmi_radius).provide(:http_ipmi_radius) do

  desc "Support for RADIUS configuration on the IPMI interface."

  require 'net/http'

  public

  def initialize(value={})
    super(value)
    @radius_keys = ['ENABLE', 'PORTNUM', 'TIMEOUT', 'IP', 'SECRET']
    @radius_payload = {}
    @login_payload = {}
  end

  def create
    Puppet.debug("CREATING NEW RESOURCE")
    @radius_payload['ENABLE'] = 1
    set_radius_cfg
  end

  def destroy
    Puppet.debug("DESTROYING NEW RESOURCE")
    @radius_payload['ENABLE'] = 0
    set_radius_cfg
  end

  def exists?
    @cookie ||= login
    get_radius_cfg
  end

  def ipaddress
    @radius_payload['IP']
  end

  def ipaddress=(ipaddress)
    @radius_payload['IP'] = ipaddress
  end

  def portnum
    @radius_payload['PORTNUM']
  end

  def portnum=(portnum)
    @radius_payload['PORTNUM'] = portnum
  end
  
  def timeout
    @radius_payload['TIMEOUT'] 
  end

  def timeout=(timeout)
    @radius_payload['TIMEOUT'] = timeout
  end
  
  def secret
    @radius_payload['SECRET'] 
  end

  def secret=(secret)
    @radius_payload['SECRET'] = secret
  end

  def flush
    set_radius_cfg
  end


  private

  RADIUS_SET_URI   = '/rpc/setradiuscfg.asp'
  RADIUS_GET_URI   = '/rpc/getradiuscfg.asp'
  RADIUS_LOGIN_URI = '/rpc/WEBSES/create.asp'

  def set_radius_cfg

    response, status = ipmi_request(RADIUS_SET_URI, "POST", @radius_payload)
    status = response.code
    if status != '200'
      raise "IPMI server error: #{status}."
    end
  end

  def get_radius_cfg

    @radius_payload['PORTNUM'] = @resource[:portnum]
    @radius_payload['TIMEOUT'] = @resource[:timeout]
    @radius_payload['IP']      = @resource[:ipaddress]
    @radius_payload['SECRET']  = @resource[:secret]

    response, status = ipmi_request(RADIUS_GET_URI, "GET")
    if status != '200'
      raise "IPMI server error: #{status}."
    end
    for key in @radius_keys
      if @radius_payload[key] == nil
        if key == 'SECRET'
          @radius_payload[key] = parse_response_for('PASSWD', response.body)
        else
          @radius_payload[key] = parse_response_for(key, response.body)
        end
      end
    end
    if parse_response_for('ENABLE', response.body) == '1'
      true
    else
      false
    end
  end

  def login 

    @login_payload['WEBVAR_USERNAME'] = @resource[:username]
    @login_payload['WEBVAR_PASSWORD'] = @resource[:password]

    response, status =  ipmi_request(RADIUS_LOGIN_URI, "POST", 
                                     @login_payload, setcookie=false)
    if status == '200' && check_response_code(response.body) == '0'
      cookie = parse_response_for('SESSION_COOKIE', response.body)
      unless cookie
        raise "Server didn't return a valid cookie after login."
      end
    else
      raise "IPMI server error: #{status}."
    end
    cookie
  end

  def parse_response_for(key, text)
    
    match = /'#{key}'\s*:\s*(')?([\w\:\.]*)(')?/.match(text)
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

  def ipmi_request(uri, type, payload={}, set_cookie=true)

    url = "http://#{@resource[:name]}#{uri}"

    if type == 'POST'
      request = Net::HTTP::Post.new(url)
      # payload = URI.encode_www_form(payload)
      # replace the following line with the line above, when we migrate Ruby to
      # 1.9.3
      payload = payload.map{|k,v| "#{k}=#{v}"}.join('&')
    else
      request = Net::HTTP::Get.new(url)
    end

    request.add_field('content-type', 'application/x-www-form-urlencoded')

    if set_cookie
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

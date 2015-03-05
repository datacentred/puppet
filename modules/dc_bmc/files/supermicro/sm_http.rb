#!/usr/bin/env ruby 

# == Synopsis 
#
#    A script to configure Supermicro IPMI. It sets up the hostname, taken as 
#    a parameter and radius authentication, details taken as parameters again.
#    Can easily be extended to configure more things in the future if needed.
#
# == Examples
#   
#    supermicro --ipaddress <ipmi-ipaddress> --hostname <ipmi-hostname> \
#               --server <radius-server> --secret <radius-secret> \
#               --password <password>
# == Usage 
#
#   supermicro [option] <parameter> ... [option] <parameter>
#
#   For help use: supermicro -h
#
# == Options
#
#   -h, --help          Displays help message
#   -i, --ipaddress     The ip address of the IPMI interface
#   -n, --hostname      What the IPMI hostname should be
#   -r, --server        The Radius server ip address
#   -s, --secret        The Radius secret 
#   -p, --password      Administrator password for the IPMI web interface
#   -u, --username      Administrator username for the IPMI web interface

require 'optparse' 
require 'ostruct'
require 'net/http'

class App
  
  attr_reader :options

  def initialize(arguments, stdin)

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
    @radius_keys = ['ENABLE', 'PORTNUM', 'TIMEOUT', 'IP', 'SECRET']

    @arguments = arguments
    @stdin = stdin
    @radius_payload = {}
    @login_payload = {}
    @network_payload = {}
    
    # Set defaults
    @options           = OpenStruct.new
    @options.ipaddress = ''
    @options.hostname  = ''
    @options.server    = ''
    @options.secret    = ''
    @options.port      = 1812
    @options.timeout   = 3
    @options.e_vlan    = 0
    @options.dhcp      = 2
    @options.channel   = 1
  end

  # Parse options, check arguments, then process the command
  def run
        
    if parsed_options? && arguments_valid? 
      process_command 
    else
      output_usage
    end
      
  end
  
  protected
  
    def parsed_options?
      
      # Specify options
      opts = OptionParser.new
      opts.on('-h', '--help')       { output_help; exit 0}
      opts.on('-i', '--ipaddress IPADDRESS') { |ipaddress|
        @options.ipaddress = ipaddress
      }
      opts.on('-n', '--hostname HOSTNAME') { |hostname|
        @options.hostname = hostname
      }
      opts.on('-r', '--server SERVER') { |ipaddress|
        @options.server = ipaddress
      }
      opts.on('-s', '--secret SECRET') { |secret|
        @options.secret = secret
      }
      opts.on('-p', '--password PASSWORD') { |password|
        @options.password = password
      }
      opts.on('-u', '--username USERNAME') { |username|
        @options.username = username
      }

            
      opts.parse!(@arguments) rescue return false
      
      true      
    end

    # True if all required arguments were provided
    def arguments_valid?
      if @options.ipaddress == ''
        return false
      elsif @options.secret == ''
        return false
      elsif @options.hostname == ''
        return false
      elsif @options.server == ''
        return false
      elsif @options.password == ''
        return false
      elsif @options.username == ''
        return false
      end
      true
    end
    
    def process_command
      options.marshal_dump.each{ |k,v| puts "#{k} => #{v}" }
      @cookie ||= login(@options.username, @options.password)
      get_radius_cfg
      set_radius_cfg
      get_network_cfg
      set_network_cfg
    end

    def output_usage
      puts "Usage: supermicro [option] <parameter> ... [option] <parameter>\n" + 
           "For help run 'supermicro -h'"
      abort
    end

    def output_help
      puts " == Synopsis 

    A script to configure Supermicro IPMI. It sets up the hostname, taken as 
    a parameter and radius authentication, details taken as parameters again.

 == Examples
   
    supermicro --ipaddress <ipmi-ipaddress> --hostname <ipmi-hostname> 
               --server <radius-server> --secret <radius-secret>
               --password <password> --username <username>
 == Usage 

   supermicro [option] <parameter> ... [option] <parameter>

   For help use: supermicro -h

 == Options

   -h, --help          Displays help message
   -i, --ipaddress     The ip address of the IPMI interface
   -n, --hostname      What the IPMI hostname should be
   -r, --server        The Radius server ip address
   -s, --secret        The Radius secret 
   -p, --password      Administrator password for the IPMI web interface
   -u, --username      Administrator username for the IPMI web interface

"
    end

  private
  
    NETWORK_SET_URI   = '/rpc/setnwconfig.asp'
    NETWORK_GET_URI   = '/rpc/getnwconfig.asp'

    RADIUS_SET_URI    = '/rpc/setradiuscfg.asp'
    RADIUS_GET_URI    = '/rpc/getradiuscfg.asp'

    LOGIN_URI         = '/rpc/WEBSES/create.asp'

    def set_radius_cfg

      response, status = ipmi_request(RADIUS_SET_URI, "POST", @radius_payload)
      status = response.code
      if status != '200'
        raise "IPMI server error: #{status}."
      end
    end

    def get_radius_cfg

      @radius_payload['PORTNUM'] = @options.port
      @radius_payload['TIMEOUT'] = @options.timeout
      @radius_payload['IP']      = @options.server
      @radius_payload['SECRET']  = @options.secret

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

    def set_network_cfg

      @network_payload['EnableVLAN']   = @options.e_vlan
      @network_payload['IPAddrSource'] = @options.dhcp
      @network_payload['ChannelNum']   = @options.channel
      @network_payload['HostName']     = @options.hostname
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

    def login(username, password) 

      @login_payload['WEBVAR_USERNAME'] = username
      @login_payload['WEBVAR_PASSWORD'] = password

      response, status =  ipmi_request(LOGIN_URI, "POST", 
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

    def ipmi_request(uri, type, payload={}, set_cookie=true)

      url = "http://#{@options.ipaddress}#{uri}"

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
      return response, status
    end

end


# Create and run the application
app = App.new(ARGV, STDIN)
app.run

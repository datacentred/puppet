#!/usr/bin/env ruby

require 'rubygems'
require 'net/http'
require 'json'
require 'uri'
require 'getoptlong'

outstring = "UNKNOWN: an unknown failure occured"
exit_code = 256

#set defaults
args = {
    :host        => 'localhost',
    :port        => 9200,
    :index       => '_all',
    :seconds     => 120,
}

opts = GetoptLong.new(
  [ '--host', '-H', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--index', '-i', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--port', '-p', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--seconds', '-s', GetoptLong::OPTIONAL_ARGUMENT ]
)

opts.each do |opt, arg|
  case opt
    when '--host'
      args[:host] = arg
    when '--port'
      args[:port] = arg.to_i
    when '--seconds'
      args[:seconds] = arg.to_i
    when '--index'
      args[:index] = arg
  end
end

begin
  uri = URI.parse("http://#{args[:host]}:#{args[:port]}/#{args[:index]}/_search")
  payload={"query" => {"range" =>
                      {"@timestamp"=>
                        {"from"=>Time.at(Time.now.to_i-args[:seconds]).utc.strftime("%FT%TZ"),
                          "to"=>Time.at(Time.now.to_i+args[:seconds]).utc.strftime("%FT%TZ")
          }}}}
  req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
  req.body = payload.to_json
  response = Net::HTTP.new(uri.host, uri.port).start {|http| http.request(req) }
  if response.code == "200"
    if JSON.parse(response.body)['hits']['total'] > 0
      outstring = "OK: Data is updating"
      exit_code = 0
    else
      outstring = "CRITICAL: Data is not updating"
      exit_code = 2
    end
  else
    outstring = "CRTICAL:  Did not receive a response HTTP Code: #{response.code}"
    exit_code = 2
  end
rescue StandardError => e
  outstring = "Error: #{e.message}"
  exit_code = 2
end

puts outstring
exit exit_code

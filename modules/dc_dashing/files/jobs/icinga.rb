host_status_map = %w(OK DOWN UNREACHABLE)
#summarise hosts status
def host_summarize(hosts, status_map)
  states = Hash.new(0)
  status_map.each do |state|
    states[state] = { label: state, value: 0 }
  end
  #tally up states
  hosts.each do |ent, status|
    states[status][:value] = states[status][:value] + 1
  end
  #get totals
  err   = 0
  total = 0
  status_map.each do |state|
    if state != 'OK' and state != 'UP'
      err = err + states[state][:value] 
    end
    total = total + states[state][:value]
  end
  states['Total'] = { label: 'Total', value: "%d / %d" % [err, total] }
  return states
end
#summarise service status
def service_summarize(service_status)
  states = Hash.new(0)
  service_status.each do |status, val|
    states[status] = { label: status, value: 0}
    states[status][:value] = val
  end
  return states
end
data_source = DataProvider.new
SCHEDULER.every '30s', :first_in => 0 do |job|
  number_down_hosts = data_source.get_number_of_down_hosts
  total_number_hosts = data_source.get_total_number_of_hosts
  send_event('hosts', {
    value: total_number_hosts, 
    max: total_number_hosts, 
    min: 0,
    moreinfo: "#{number_down_hosts} of #{total_number_hosts} are down"
  })

  #Assemble Icinga Down Hosts Table
  down_hosts = data_source.get_list_of_down_hosts
  host_headers = [
      {
      cols: [
        {value: "HostName"},
        {value: "Status"},
      ]
    }
  ]
  host_rows = Array.new
  down_hosts.each do |host, status|
    host_rows << {"cols" => [{"value" => host}, {"value" => status}] }
  end
  send_event('host-problems', { hrows: host_headers, rows: host_rows})
  #down services
  down_hosts_and_service = data_source.get_list_of_down_hosts_with_services
  service_headers = [
      {
      cols: [
        {value: "HostName"},
        {value: "Service-Name"},
        {value: "Service-Status"},
      ]
    }
  ]
  service_rows = Array.new
  down_hosts_and_service.each do |host, services|
    services.each do |tuple|
      tuple.each do |serv, status|
        service_rows << {"cols" => [{"value" => host},
                                    {"value" => serv},
                                    {"value" => status}
        ]}
      end
    end
  end
  send_event('service-problems', { hrows: service_headers,
                                   rows: service_rows})
  #Summaries
  all_hosts    = data_source.get_all_hosts
  all_services = data_source.get_current_service_status
  host_states    = host_summarize(all_hosts, host_status_map)
  service_states = service_summarize(all_services)
  send_event('service_status', { services: service_states })
  send_event('host_status', { hosts: host_states } )
end

dataSource = DataProvider.new
SCHEDULER.every '5m', :first_in => 0 do |job|
  data = dataSource.get_on_call_stats
  on_call = data[0]
  send_event('on_call', { text: on_call['name'],
                          moreinfo: "Until #{on_call['end']}"
              })
  trigg_incidents = dataSource.get_triggered_incidents.length
  acked_incidents = dataSource.get_acknowledged_incidents.length
  send_event('triggered_incidents', {
              current: trigg_incidents
             })
  send_event('acked_incidents', {
              current: acked_incidents
            })
  incidents = dataSource.get_all_incidents
  incidents = incidents.length
  acked_incidents = dataSource.get_acknowledged_incidents
  send_event('incidents', {
    value: acked_incidents, 
    max: incidents, 
    min: 0,
    moreinfo: "#{acked_incidents}/#{incidents} incidents have been acknowledged"
  })
end

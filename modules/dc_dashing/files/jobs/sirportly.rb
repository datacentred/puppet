dataProvider = DataProvider.new
SCHEDULER.every '30s', :first_in => 0 do |job|
  tickets    = dataProvider.get_summary_of_open_tickets
  to_be_handled = tickets['new'] + tickets['waiting_for_staff']
  total = tickets['new'] + tickets['waiting_for_customer'] + tickets['waiting_for_staff']
  send_event('in_flight', {
    value: to_be_handled, 
    max: total, 
    min: 0,
    moreinfo: "#{to_be_handled} out of #{total} tickets waiting on staff"
  })
end

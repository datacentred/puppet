dataSource = DataProvider.new
SCHEDULER.every '30s', :first_in => 0 do |job|
  numberOfVCPUsUsed = dataSource.get_total_vcpus_used
  runningVMs     = dataSource.get_total_number_of_running_vms
  memoryUsage    = dataSource.get_total_memory_usage
  send_event('number_vcpus_used', {current: numberOfVCPUsUsed})
  send_event('ram-hypervisor', {current: convert_num(memoryUsage)})
  send_event('running_vms-hypervisor', {current: runningVMs})
end

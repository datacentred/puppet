def convert_num(num)
  if num >= 1024**6
    "#{(num / (1024**6)).ceil} EB"
  elsif num >= 1024**5
    "#{(num / (1024**5)).ceil} PB"
  elsif num >= 1024**4
    "#{(num / (1024**4)).ceil} TB"
  elsif num >= 1024**3
    "#{(num / (1024**3)).ceil} GB"
  elsif num >= 1024**2
    "#{(num / (1024**2)).ceil} MB"
  elsif num >= 1024
    "#{(num / 1024).ceil} KB"
  else
    "#{num}B"
  end
end
data_source = DataProvider.new
SCHEDULER.every '30s', :first_in => 0 do |job|
  available_space = convert_num(data_source.get_available_cluster_space)
  max_capacity    = convert_num(data_source.get_ceph_max_capacity)
  iops            = data_source.get_ceph_iops
  send_event('cluster_space', {
    value: available_space,
    max: max_capacity,
    min: 0,
    moreinfo: "There currently is #{available_space}/#{max_capacity} available"})
  send_event('cluster_iops', points: iops)
end

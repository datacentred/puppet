# == Class: dc_icinga2::timeperiods
#
# Define timeperiods
#
class dc_icinga2::timeperiods {

  icinga2::object::timeperiod { '24x7':
    import       => 'legacy-timeperiod',
    display_name => '24x7 Timeperiod',
    ranges       => {
      'monday'    => '00:00-24:00',
      'tuesday'   => '00:00-24:00',
      'wednesday' => '00:00-24:00',
      'thursday'  => '00:00-24:00',
      'friday'    => '00:00-24:00',
      'saturday'  => '00:00-24:00',
      'sunday'    => '00:00-24:00',
    },
    target       => '/etc/icinga2/zones.d/global-templates/timeperiods.conf',
  }

}

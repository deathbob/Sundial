require 'sun_calculator'
puts
puts

@s = SolarCalculator.new

def printer(str)
  print str, @s.send(str.strip.intern), "\n"
end

#
# @s.address = "201 West Broad Street, Richmond, VA"
# @s.address = @s.external_ip
# puts "lat_long", @s.lat_long


puts "Driver Block One ----------------------"
printer "  current_julian_cycle "
printer "   current_julian_date "
printer "approximate_solar_noon "
printer '    solar_mean_anomaly '
printer "    equation_of_center "
printer "    ecliptic_longitude "
printer "       right_ascension "
printer "declination_of_the_sun "
puts

puts "Driver Block Two ----------------------"
printer "         l_sun "
printer "           jpp "
printer " sunset_jd_two "
puts

puts "Driver Block Three ----------------------"
printer " sidereal_time "
printer "    hour_angle "
printer " solar_transit "
printer '    sunrise_jd '
printer "     sunset_jd "
puts
printer "   sunrise "
printer "    sunset "


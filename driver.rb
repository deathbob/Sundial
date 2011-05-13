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

printer "  current_julian_cycle "
printer "   current_julian_date "
printer "approximate_solar_noon "
printer '    solar_mean_anomaly '
printer "    equation_of_center "
printer "    ecliptic_longitude "
printer "       right_ascension "
printer "declination_of_the_sun "
puts
printer " l_sun "
printer " jpp "
printer "sunset_jd_two "
puts "XXXXXXXXXXXXXXXX"

printer "sidereal_time "
puts
#printer "hour_angle_two "
printer "hour_angle "
printer "solar_transit "

#printer "hour_angle "

printer 'sunrise_jd '
# JD 2450499.236300 is
# CE 1997 February 19 17:40:16.3 UT  Wednesday
#JD 2455694.789580 is
#CE 2011 May 13 06:56:59.7 UT  Friday

printer " sunset_jd "
#JD 2455694.786370 is
#CE 2011 May 13 06:52:22.4 UT  Friday
# JD 2455694.791220 is
# CE 2011 May 13 06:59:21.4 UT  Friday
printer " sunrise "
printer "  sunset "


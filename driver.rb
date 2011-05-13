require 'sun_calculator'

@s = SolarCalculator.new

def printer(str)
  print str, @s.send(str.strip.intern), "\n"
end

#
# @s.address = "201 West Broad Street, Richmond, VA"
# @s.address = @s.external_ip
#puts "lat_long", @s.lat_long

print "current julian cycle ", @s.current_julian_cycle, "\n"
print "solar noon ",  @s.approximate_solar_noon, "\n"
print 'solar_mean_anomaly ', @s.solar_mean_anomaly, "\n"
print "equation of center ", @s.equation_of_center, "\n"
printer "ecliptic_longitude "
printer "right_ascension "
printer "solar_transit "
printer "declination_of_the_sun "
printer "hour_angle "

printer 'sunrise '
# JD 2450499.236300 is
# CE 1997 February 19 17:40:16.3 UT  Wednesday
#JD 2455694.789580 is
#CE 2011 May 13 06:56:59.7 UT  Friday

printer "sunset "
#JD 2455694.786370 is
#CE 2011 May 13 06:52:22.4 UT  Friday
# JD 2455694.791220 is
# CE 2011 May 13 06:59:21.4 UT  Friday

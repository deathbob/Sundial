require 'sun_calculator'

@s = SolarCalculator.new

def printer(str)
  print str, @s.send(str.strip.intern), "\n"
end


@s.address = "201 West Broad Street, Richmond, VA"
@s.address = @s.external_ip

puts "lat_long", @s.lat_long
print "current julian cycle ", @s.current_julian_cycle, "\n"
print "solar noon ",  @s.approximate_solar_noon, "\n"
print 'solar_mean_anomaly ', @s.solar_mean_anomaly, "\n"
print "equation of center ", @s.equation_of_center, "\n"
printer "ecliptic_longitude "
printer "solar_transit "
printer "declination_of_the_sun "
printer "hour_angle "
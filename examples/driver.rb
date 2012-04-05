require './lib/sundial'
puts
puts

@s = Sundial.new

def printer(str)
  print str, @s.send(str.strip.intern), "\n"
end

#
#@s.address = "201 West Broad Street, Richmond, VA"
#@s.address = "6526 Stuart Ave, Richmond, VA, 23226"
#@s.date = (Date.today + 110.days + 1.year).jd

#@s.address = "Amsterdam, Netherlands"
@s.address = @s.external_ip
#@s.date = Date.parse("2004-04-01").jd
#@s.date = Date.parse("2011-12-24").jd


#puts "lat_long", @s.lat_long

printer "  latitude "
printer ' longitude '
printer ' longitude_west '
#printer ' get_offset '
printer 'get_timezone_offset '

puts "Driver Block One ----------------------"
printer "   current_julian_date "
print   "           JULIAN_2000 ", "2451545", "\n"
printer '                  jrd     '
printer "  current_julian_cycle "
printer '    solar_mean_anomaly '
printer "    equation_of_center "
printer "    ecliptic_longitude "
printer "       right_ascension "
printer "declination_of_the_sun "
puts

puts "Driver Block Two ----------------------"
printer "                 l_sun "
printer "                   jpp "
printer "         sunset_jd_two "
puts

puts "Driver Block Three ----------------------"
printer "         sidereal_time "
printer "            hour_angle "
printer "        hour_angle_two "
printer "approximate_solar_noon "
printer "         solar_transit "
puts

puts "Driver Block Four"
printer '      wiki_set '
printer '    sunrise_jd '
printer "     sunset_jd "
printer "   sunrise "
printer "    sunset "
printer " sunrise_f "
printer "  sunset_f "
printer ' length_of_day '
printer ' asn_date '

def format_datetime(dt)
  dt.strftime("%B %e %Y %T")
end

puts "the equivalent of 9 AM on the solstice on this day would be", format_datetime(@s.nine)
puts "the equivalent of 5 pm on the solstice on this day would be", format_datetime(@s.five)




# Looks like the times are good, need to grab the timezone of the address being used and offset the UTC results by that much

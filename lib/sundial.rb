require 'date'
require 'geokit'
require 'open-uri'
require 'json'
require 'active_support/time'

require_relative 'numeric_extensions'

class Sundial

  attr_accessor :address, :date, :ip, :offset, :ll
  
  def initialize
    @address = "Richmond, Virginia"
  end

  JULIAN_2000 = 2451545
  
  def local_time
    DateTime.now
  end
  
  def whatismyip
    "http://checkip.dyndns.org"
  end

  def current_julian_date
    # http://stackoverflow.com/questions/5095456/using-the-ruby-date-class-for-astronomical-data
    @date || Date.today.jd
  end

  def external_ip
    @ip ||= open(whatismyip).read[/[\d\.]+/]
    @ip
#    '75.75.82.80'        
  end

  def lat_long
    @ll ||= Geokit::Geocoders::MultiGeocoder.geocode(@address)
  end

  def longitude
    lat_long.lng
  end

  def latitude
    lat_long.lat
  end

  def longitude_west
    -longitude
  end



  def get_offset
    # see also http://www.hostip.info/
    foo = open("http://www.earthtools.org/timezone-1.1/#{latitude}/#{longitude}").read
    bar = foo.match(/<offset>(.*)<\/offset>/) if foo
    if bar
      @offset = bar[1].to_i
    end
  end

  def get_timezone_offset
    foo = open("http://www.askgeo.com/api/123016/vgdgoafgkvgdk6i9j26unjep4/timezone.json?points=#{latitude}%2C#{longitude}").read
    bar = JSON.parse(foo)
    if bar && bar['message'] == 'ok'
      @offset = bar['data'].first['currentOffsetMs'].to_i / 3600000
    end
  end

  def jrd
    current_julian_date - JULIAN_2000
  end

  def current_julian_cycle
    (current_julian_date - JULIAN_2000 - 0.0009 - (longitude_west / 360.0)).round
  end


  def solar_mean_anomaly # Mearth
    # returns in degrees, 87.18
    # Not sure if using approximate_solar_noon instead of current_julian_date is helpful or not
    # Following this http://www.astro.uu.nl/~strous/AA/en/reken/zonpositie.html using current_julian_date
#    ((357.5291 + 0.98560028 * (approximate_solar_noon - JULIAN_2000)) % 360).round(4) # this one is how wikipedia has it
     ((357.5291 + 0.98560028 * (current_julian_date - JULIAN_2000)) % 360).round(4) # this on better for netherlands
  end

  def equation_of_center # Cearth
    # returns in degrees 1.91
    ((1.9148 * Math.sin(solar_mean_anomaly.degrees)) + (0.0200 * Math.sin((2 * solar_mean_anomaly).degrees)) + (0.0003 * Math.sin((3 * solar_mean_anomaly).degrees))).round(4)
  end

  def ecliptic_longitude # λsun
    # returns in degrees 12.0321
#    (solar_mean_anomaly + 102.9372 + 180) % 180
    (solar_mean_anomaly + 102.9372 + equation_of_center + 180) % 360
  end

  def obliquity_of_the_equator #  ε
    23.45
  end

  def l_sun
    (solar_mean_anomaly + 102.9372 + 180) % 180
  end

  def sunset_jd_two
    jpp + 0.0053 * Math.sin(solar_mean_anomaly.degrees) - 0.0069 * Math.sin((2 * l_sun).degrees)
  end

  def approximate_solar_noon # J(*)
    (JULIAN_2000 + 0.0009 + (longitude_west / 360.0) + current_julian_cycle).round(4)
  end

  def asn_date
    DateTime.jd(approximate_solar_noon)
  end

  def solar_transit
    # Losing a lot of precision here :(
    # not sure of these units, 2453097.0113
#                              2453097.01224153
#     (current_julian_date +    (0.0053 * Math.sin(solar_mean_anomaly.degrees)) - (0.0069 * Math.sin((2 * ecliptic_longitude).degrees))).round(4)
     (approximate_solar_noon + (0.0053 * Math.sin(solar_mean_anomaly.degrees)) - (0.0069 * Math.sin((2 * ecliptic_longitude).degrees))).round(4)
  end

  def declination_of_the_sun # δsun
    # returns in degrees 4.7585
    (Math.asin(Math.sin(ecliptic_longitude.degrees) * Math.sin(23.45.degrees))).round(5).radians
  end


  def right_ascension # αsun
    (ecliptic_longitude + (-2.4680 * Math.sin((2 * ecliptic_longitude).degrees)) + (0.0530 * Math.sin((4 * ecliptic_longitude).degrees)) - (0.0014 * Math.sin((6 * ecliptic_longitude).degrees))).round(4)
  end

  def sidereal_time # θ
    (((280.1600 + 360.9856235 * (current_julian_date - JULIAN_2000)) - (longitude_west)) % 360).round(4)
  end

  def hour_angle_two
    sidereal_time - right_ascension
  end

  def hour_angle
    # returns output in degrees
    top = Math.sin(-0.83.degrees) - (Math.sin(latitude.degrees) * Math.sin(declination_of_the_sun.degrees))
    bottom = Math.cos(latitude.degrees) * Math.cos(declination_of_the_sun.degrees)
    tb = top / bottom
    if((tb < -1.0) || (tb > 1.0))
      return 0 # there is no sunrise or sunset on the given date for the given lat / long.
      # Not sure what to return here, just hope for now that it doesn't happen.
    end
    # acos will blow up if input not in range (-1..1)
    (Math.acos(tb).radians).round(4)
  end

  def jpp
    JULIAN_2000 + 0.0009 + (hour_angle + (longitude_west)) * 1 / 360.0 + 1 * current_julian_cycle
  end

  def wiki_set # ends up close to sunset_jd, which is good i think
    JULIAN_2000 + 0.0009 + (((hour_angle  + (longitude_west)) / 360) + current_julian_cycle + 0.0053 * Math.sin(solar_mean_anomaly.degrees)) - 0.0069 * Math.sin((2 * ecliptic_longitude).degrees)
  end

  def sunset_jd
#    puts "#{JULIAN_2000} + 0.0009 + (((#{hour_angle} + #{longitude}) / 360.0 ) + #{current_julian_cycle} + 0.0053 * Math.sin(#{solar_mean_anomaly})) - 0.0069 * Math.sin(2 * #{ecliptic_longitude})"
#    foo = JULIAN_2000 + 0.0009 + (((hour_angle + longitude) / 360.0 ) + current_julian_cycle + 0.0053 * Math.sin(solar_mean_anomaly)) - 0.0069 * Math.sin(2 * ecliptic_longitude)
    foo = jpp + 0.0053 * Math.sin(solar_mean_anomaly.degrees) - 0.0069 * Math.sin((2 * ecliptic_longitude).degrees)
    foo.round(4)
  end

  def sunrise_jd
    foo = solar_transit - (sunset_jd - solar_transit)
    foo.round(4)
  end

  def sunset
    foo = DateTime.jd(sunset_jd) + 12.hours
#    foo = foo.new_offset(local_time.offset)
    foo
  end

  def sunrise
    foo = DateTime.jd(sunrise_jd) + 12.hours
#    foo = foo.new_offset(local_time.offset)
    foo
  end

  def sunrise_f
    (sunrise + @offset.to_i.hours)
  end

  def sunset_f
    (sunset + @offset.to_i.hours)
  end

  def length_of_day
    (sunset - sunrise) * 24
  end

  def hour_ratio
    length_of_day / 12.0
  end

  def nine
    sunrise_f + (2 * hour_ratio).hours
  end

  def five
    sunrise_f + (10 * hour_ratio).hours
  end

  def format_datetime(dt)
    dt.strftime("%B %e %Y %T")
  end





end



#Sundial.new.get_location

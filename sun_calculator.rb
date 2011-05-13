class Numeric
  def degrees
    self * Math::PI / 180
  end

  def radians
    self * 180 / Math::PI
  end
end

class SolarCalculator

  require 'rubygems'
  require 'date'
  require 'geokit'
  require 'open-uri'

  JULIAN_2000 = 2451545
  attr_accessor :address


    def whatismyip
      "http://www.whatismyip.com/automation/n09230945.asp"
    end

    def external_ip
      open(whatismyip).read
    end

    def lat_long
      @ll ||= Geokit::Geocoders::MultiGeocoder.geocode(@address)
  #    @ll = Geokit::Geocoders::YahooGeocoder.geocode(@address)
    end




  def current_julian_date
    # http://stackoverflow.com/questions/5095456/using-the-ruby-date-class-for-astronomical-data
    Date.today.ajd.to_f
    2453097
  end

  def longitude
#    lat_long.lng
    -5
  end

  def latitude
#    lat_long.lat
    52
  end



  def current_julian_cycle
    (current_julian_date - JULIAN_2000 - 0.0009 - (longitude / 360)).round
  end

  def approximate_solar_noon
    JULIAN_2000 + 0.0009 + (longitude / 360) + current_julian_cycle
  end

  def solar_mean_anomaly # Mearth
    # returns in degrees, 87.18
    (357.5291 + 0.98560028 * (approximate_solar_noon - JULIAN_2000)) % 360
    (357.5291 + 0.98560028 * (current_julian_date - JULIAN_2000)) % 360    
  end

  def equation_of_center # Cearth
    # returns in degrees 1.91
    (1.9148 * Math.sin(solar_mean_anomaly.degrees)) + (0.0200 * Math.sin(2 * solar_mean_anomaly.degrees)) + (0.0003 * Math.sin(3 * solar_mean_anomaly.degrees))
  end

  def ecliptic_longitude # λsun
    # returns in degrees 12.0321
    (solar_mean_anomaly + 102.9372 + equation_of_center + 180) % 180
  end

  def obliquity_of_the_equator #  ε
    23.45
  end

  def solar_transit
    # not sure of these units, 2453097.0113
    approximate_solar_noon + (0.0053 * Math.sin(solar_mean_anomaly.degrees)) - (0.0069 * Math.sin(2 * ecliptic_longitude))
  end

  def declination_of_the_sun # δsun
    # returns in degrees 4.7585
    Math.asin(Math.sin(ecliptic_longitude.degrees) * Math.sin(23.45.degrees)).radians
  end


  def right_ascension # αsun
    #Math.atan(Math.sin(ecliptic_longitude) +
    ecliptic_longitude + (-2.4680 * Math.sin((2 * ecliptic_longitude).degrees)) + (0.0530 * Math.sin((4 * ecliptic_longitude).degrees))  - (0.0014 * Math.sin((6 * ecliptic_longitude).degrees))
  end

  def sidereal_time # θ
    280.1600 + 360.9856235 * (current_julian_date - JULIAN_2000)
  end


  def hour_angle_two
    Math.sin(latitude)
  end

  def hour_angle
    top = Math.sin(-0.83) - (Math.sin(latitude.degrees) * Math.sin(declination_of_the_sun.degrees))
#    puts top
    bottom = Math.cos(latitude.degrees) * Math.cos(declination_of_the_sun.degrees)
#    puts bottom
    tb = top / bottom
#    puts tb
    # blowing up? grr
    Math.acos(tb)
    # 0
    # 1.5
    # Math::PI
  end


  def sunset
    JULIAN_2000 + 0.0009 + (((hour_angle  + longitude) / 360 ) + current_julian_cycle + 0.0053 * Math.sin(solar_mean_anomaly)) - 0.0069 * Math.sin(2 * ecliptic_longitude)
  end

  def sunrise
    solar_transit - (sunset - solar_transit)
  end




end



#SolarCalculator.new.get_location
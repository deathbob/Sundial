require 'minitest/autorun'

cal = File.join(File.dirname(__FILE__), '..', 'lib', 'sun_calculator.rb')

puts File.exists? cal

require_relative File.join('..', 'lib', 'sun_calculator')

class SunCalculatorTest < MiniTest::Unit::TestCase
  def setup
    @sc = SolarCalculator.new
  end

  def test_local_time
    assert @sc.local_time.to_i == DateTime.now.to_i
  end
  
  def test_julian_2000
    assert   SolarCalculator::JULIAN_2000 == 2451545
  end
  
  def test_whatismyip 
    assert @sc.whatismyip == "http://www.whatismyip.org/"
  end

  describe SolarCalculator do
    before do
      @sc = SolarCalculator.new
    end

    describe 'current_julian_date' do
      it 'should be today when no default is given' do
        @sc.current_julian_date.must_equal Date.today.jd
      end
      it 'should be the default if default is given' do
        cow = (Date.today - 1.days).jd
        @sc.date = cow
        @sc.current_julian_date.must_equal cow
      end
    end
  
    describe 'address' do
      # Address just needs to be something that can be geocoded.
      it 'should default to my address' do
        @sc.address.must_equal "Richmond, Virginia"
      end
    
      it 'should be whatever is given if set' do
        cow = "71.1.2.3"
        @sc.address = cow
        @sc.address.must_equal cow
      end
    end
  
    describe 'lat_long' do
      before do
        @latlng = Geokit::LatLng.new(37.5407246, -77.4360481)
        @foo = Geokit::GeoLoc.new({:city =>'Richmond', :state => 'VA', :lat => @latlng.lat, :lng => @latlng.lng, :country_code => "US"})
      end
      # How to work VCR in here?
      # it 'should geocode the default address' do
      #   @sc.lat_long.must_equal @foo
      # end
      
      describe 'given default address geocoded correctly' do
        before do
          @sc.ll = @foo
        end
        it 'should set latitude' do
          @sc.latitude.must_be_close_to @latlng.lat
        end
        it 'should set longitude' do
          @sc.longitude.must_be_close_to @latlng.lng
        end
        it 'should set the longitude_west to negative latitude' do
          @sc.longitude_west.must_equal -@sc.longitude
        end
        describe "Getting the offset for the lat & lng" do
          it 'should get_offset' do
            @sc.get_offset.must_equal -5
            @sc.offset.must_equal -5
          end
          it 'should get_timezone_offset' do
            @sc.get_timezone_offset.must_equal -4
            @sc.offset.must_equal -4
          end
        end
      end
      
    end
    
    describe 'jrd' do
      it 'should be the current_julian_date - JULIAN_2000' do
        @sc.jrd.must_equal @sc.current_julian_date - SolarCalculator::JULIAN_2000
      end
    end
    
  end  
  
end

# cloony

# expected_musts = %w(must_be
#                     must_be_close_to
#                     must_be_empty
#                     must_be_instance_of
#                     must_be_kind_of
#                     must_be_nil
#                     must_be_same_as
#                     must_be_silent
#                     must_be_within_delta
#                     must_be_within_epsilon
#                     must_equal
#                     must_include
#                     must_match
#                     must_output
#                     must_raise
#                     must_respond_to
#                     must_send
#                     must_throw)

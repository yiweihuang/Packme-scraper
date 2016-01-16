require 'oga'
require 'open-uri'

module TripDestination
  # This class get the user account as an input
  # return a hash of user's badges information
  class TripDestinationName
    Trip_URL = 'http://www.triphobo.com/places'
    Trip_CITY = "//div[@class='adda-cont-name']//span//h1"
    Trip_COUNTRY = "//span[@class='parent-location']"
    PAGE = "//li[@data-page]"

    def initialize
      parse_page
      last_page = get_last_page.to_i
      for i in 1..last_page
        parse_place(i)
        parse_trip_place_city  #array
        parse_trip_place_country  #array
        #save city & country 
        File.open("../destination/city.rb", "w+") do |f|
          f.puts(parse_trip_place_city,parse_trip_place_country)
        end
      end
    end
    
    def get_last_page
      @last_page ||= parse_get_page[-2]
    end
    
    def trip_place_city
      @trip_place_city ||= parse_trip_place_city
    end
    
    def trip_place_country
      @trip_place_country ||= parse_trip_place_country
    end

    private
    
    def parse_page
        url = "#{Trip_URL}"
        @document = Oga.parse_html(open(url))
    end
    
    def parse_get_page
      @document.xpath(PAGE).map do |page|
      last_page = page.text
      end
    end
    # last page is  = parse_get_page[-2]
    
    def parse_place(i)
      url = "#{Trip_URL}?page=#{i}"
      @document_page = Oga.parse_html(open(url))
    end
    
    def parse_trip_place_city
      @document_page.xpath(Trip_CITY).map do |trip_city|
      city = trip_city.text
      end
    end
    
    def parse_trip_place_country
      @document_page.xpath(Trip_COUNTRY).map do |trip_country|
      country = trip_country.text.split('',2)[1]
      end
    end
    
    
    
  end
end
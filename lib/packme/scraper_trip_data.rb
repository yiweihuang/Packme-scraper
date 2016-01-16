require 'oga'
require 'open-uri'
require '../destination/city.rb'

module TripPlan
  # This class get the user account as an input
  # return a hash of user's badges information
  class PlanData
    Trip_URL = 'http://www.triphobo.com/tripplans'
    Trip_DATE = "//div[@class='iti-top-title']"
    Trip_DATE_XPATH = 'h4'
    Trip_LINK = "//a[@title='Click to view']"
    Trip_IMG = "//div[@class='iti-content-top']//img"

    def initialize(name)
      name = name.downcase
      parse_data(name)
    end

    def trip_data
      @trip_data ||= parse_trip_data
    end
    
    def trip_link
      @trip_link ||= parse_trip_link
    end
    
    def trip_img
      @trip_img ||= parse_trip_img
    end
    
    private

    def parse_data(name)
      url = "#{Trip_URL}/#{name}"
      @document = Oga.parse_html(open(url))
    end

    def parse_trip_data
      @document.xpath(Trip_DATE).map do |trip_place|
      place = trip_place.text.split("\n\t\t\t\t\t\t")[0]
      days = trip_place.xpath(Trip_DATE_XPATH).text
      [place, days]
      end
    end
    
    def parse_trip_link
      @document.xpath(Trip_LINK).map do |trip_url|
      url = trip_url.attributes[1].value
      end
    end
    
    def parse_trip_img
      @document.xpath(Trip_IMG).map.with_index do |trip_graph,index|
        if (index % 2 == 0) then
          graph = trip_graph.attributes[0].value
        end
      end
    end
    #parse_trip_img.compact
    
  end
end
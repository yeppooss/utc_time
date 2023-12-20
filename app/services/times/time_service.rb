module Times
  class TimeService
    GEOCODER_API_URL = 'https://geocode.maps.co/search?q='.freeze
    def initialize(params:)
      @cities = params.fetch(:cities, nil)
      @result = {}
    end

    def perform
      load_time_for_cities
      prepare_response
    end

    private
    def load_time_for_cities
      return if @cities.nil?

      @cities.each do |city|
        lat, lon = get_citi_ll(city)
        (@result[city] = 'Error to resolve') and next if lat.nil? or lon.nil?

        timezone = Timezone.lookup(lat, lon)
        @result[city] = timezone.time(Time.now.utc)
      end
    end

    def get_citi_ll(city)
      connection = Faraday.new(
        url: "#{GEOCODER_API_URL}#{city}",
      )
      response = connection.get
      body = JSON.parse(response.body)
      lat = body[0]['lat']
      lon = body[0]['lon']

      [lat, lon]
    end
    def prepare_response
      @result['utc'] = Time.now.utc
      @result
    end
  end
end
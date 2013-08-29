require "lita"

module Lita
  module Handlers
    class Weather < Handler

      def self.default_config(config)
        config.api_key = nil
      end

      route %r{^weather ([0-9]{5})(|-[0-9]{4})$}i, :weather_zip, command: true, help: {
        "weather <zipcode|airport|city,state>" => "Returns current weather conditions for the specified location."
      }

      route %r{^weather ([a-z0-9]{3,4})$}i, :weather_airport, command: true

      route %r{^weather (.+\s*,\s*[a-z]{2})$}i, :weather_city, command: true

      def weather_zip(response)
        return if Lita.config.handlers.weather.api_key.nil?
        response.reply get_conditions(response.matches[0][0])
      end

      def weather_airport(response)
        return if Lita.config.handlers.weather.api_key.nil?
        response.reply get_conditions(response.matches[0][0])
      end

      # For a city search, we send the request to google, and get the lat/lng pairs
      # then send the coordinates to weather underground
      def weather_city(response)
        return if Lita.config.handlers.weather.api_key.nil?

        resp = http.get('http://maps.googleapis.com/maps/api/geocode/json',
          address: response.matches[0][0],
          sensor: 'false')

        raise 'GoogleFail' unless resp.status == 200

        obj = MultiJson.load(resp.body)

        raise 'GoogleError' unless obj['status'].eql?('OK')

        location = obj['results'].first['geometry']['location']

        response.reply get_conditions("#{location['lat']},#{location['lng']}")

      rescue
        response.reply 'Sorry, but there was a problem locating that city.'
      end

      private

      def get_conditions(query)
        # http://api.wunderground.com/api/KEY/conditions/q/37.7749295,-122.4194155.json
        resp = http.get("http://api.wunderground.com/api/#{Lita.config.handlers.weather.api_key}/conditions/q/#{query}.json")

        raise 'InvalidResponse' unless resp.status == 200
        
        obj = MultiJson.load(resp.body)
        
        # check for an error response
        if obj['response']['error']
          return obj['response']['error']['description']
        end

        current = obj['current_observation']

        line = []
        line << "#{current['display_location']['full']} (#{current['display_location']['zip']})"
        line << "#{current['weather']} @ #{current['temperature_string']}"
        line << "Humidity: #{current['relative_humidity']}, Winds: #{current['wind_string']}"

        line.join ' - '

      rescue
        'Sorry, but there was a problem retrieving weather information.'
      end

    end

    Lita.register_handler(Weather)
  end
end

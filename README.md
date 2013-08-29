# lita-weather

[![Build Status](https://travis-ci.org/webdestroya/lita-weather.png)](https://travis-ci.org/webdestroya/lita-weather)
[![Code Climate](https://codeclimate.com/github/webdestroya/lita-weather.png)](https://codeclimate.com/github/webdestroya/lita-weather)
[![Coverage Status](https://coveralls.io/repos/webdestroya/lita-weather/badge.png)](https://coveralls.io/r/webdestroya/lita-weather)

**lita-weather** is a handler for [Lita](https://github.com/jimmycuadra/lita) that provides current weather information for a specific location.

## Installation

Add lita-weather to your Lita instance's Gemfile:

``` ruby
gem "lita-weather"
```

## Configuration

This plugin requires a developer account on WeatherUnderground.

``` ruby
Lita.configure do |config|
  config.handlers.weather.api_key = "blahblahblahblah"
end
```

## Usage

```
Lita: weather 90210
Lita: weather LAX
Lita: weather beverly hills, ca
```

## License

[MIT](http://opensource.org/licenses/MIT)

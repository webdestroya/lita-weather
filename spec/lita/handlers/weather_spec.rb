require "spec_helper"

describe Lita::Handlers::Weather, lita_handler: true do

  before do
    Lita.config.handlers.weather.api_key = ENV['WUNDERGROUND_KEY']
  end

  it { routes_command("weather 90210").to(:weather_zip) }
  it { routes_command("weather 90210-1234").to(:weather_zip) }


  it { routes_command("weather los angeles, ca").to(:weather_city) }


  it { doesnt_route_command("weather").to(:weather_zip) }
  it { doesnt_route_command("weather lax").to(:weather_city) }

  it { doesnt_route_command("weather").to(:weather_zip) }
  it { doesnt_route_command("weather").to(:weather_city) }
  it { doesnt_route_command("weather").to(:weather_airport) }

  it { doesnt_route_command("weather ca").to(:weather_city) }


  it "checks invalid zipcode" do
    send_command "weather 11111"
    expect(replies.last).to_not be_nil
    expect(replies.last).to eq("No cities match your search query")
  end


  it "checks valid zipcode" do
    send_command "weather 90210"
    expect(replies.last).to_not be_nil
    expect(replies.last).to include("Beverly Hills, CA")
  end

  it "checks valid city" do
    send_command "weather los angeles, ca"
    expect(replies.last).to_not be_nil
    expect(replies.last).to include("Los Angeles")
  end

  it "checks valid airport" do
    send_command "weather LAX"
    expect(replies.last).to_not be_nil
    expect(replies.last).to include("Los Angeles International")
  end


end

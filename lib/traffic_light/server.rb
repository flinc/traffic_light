require 'sinatra/base'
require 'erb'
require 'json'

module TrafficLight
  class Server < Sinatra::Base

    dir = File.dirname(File.expand_path(__FILE__))

    set :views,  "#{dir}/views"
    set :public, "#{dir}/public"
    set :static, true
    # concurrency is so 2009
    set :lock,   true

    get '/' do
      erb(:template, {}, :traffic_light => options.traffic_light)
    end

    get '/lights' do
      options.traffic_light.status.to_json
    end

    post '/lights/?' do
      options.traffic_light.status = params
      halt 200, options.traffic_light.status.to_json
    end

    post '/lightmode/?' do
      options.traffic_light.multi_light_mode = (params["multi_light_mode"] == "true")
      halt 200, options.traffic_light.status.to_json
    end

    def self.start(port, traffic_light)
      set :traffic_light, traffic_light
      TrafficLight::Server.run! :port => port
    end

  end
end
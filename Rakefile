require 'bundler'
require './lib/traffic_light'

task :default => [:cijoe]

task :setup do
  @traffic_light = TrafficLight::Controller.new(true)
  @config_file = YAML::load File.open("config.yml")
end

desc "Start the web interface"
task :server => [:setup] do
  TrafficLight::Server.start(9797, @traffic_light)
end

desc "Watch CI Joe build status"
task :cijoe => [:setup] do
  options = @config_file["traffic_light"]["cijoe_build_status"]
  TrafficLight::CijoeBuildStatus.new(@traffic_light, options)
end
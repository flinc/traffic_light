$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'net/http'
require 'uri'
require 'rubygems'

require 'traffic_light/version'
require 'traffic_light/cijoe_build_status'
require 'traffic_light/digital_output'
require 'traffic_light/controller'
require 'traffic_light/server'

module TrafficLight
end
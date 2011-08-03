require 'rainbow'

module TrafficLight
  class Controller

    USB_ADRESS = 2

    # Maps light colors to bits
    LIGHTS = {
      :red => 0,
      :yellow => 1,
      :green  => 2
    }

    K8055_CLI_LOCATION = File.dirname(__FILE__) + "/../../bin/k8055"

    attr_accessor :current_state, :multi_light_mode

    def initialize(enable_multi_light = false)
      @current_state = TrafficLight::DigitalOutput.new
      @multi_light_mode = enable_multi_light
    end

    def log(msg)
      puts Time.now.strftime("%m/%d/%Y %H:%M:%S") << " | " << msg
    end

    def on!
      LIGHTS.keys.each { |color| turn_on(color) }
      update!
    end

    def turn_on(color)
      @current_state.reset! unless multi_light_mode
      @current_state[LIGHTS[color]] = 1
      log "Turned on #{color}".background(color)
    end

    def turn_on!(color)
      turn_on(color)
      update!
    end

    def off!
      LIGHTS.keys.each { |color| turn_off(color) }
      update!
    end

    def turn_off(color)
      @current_state[LIGHTS[color]] = 0
      log "Turned off #{color}".foreground(color)
    end

    def turn_off!(color)
      turn_off(color)
      update!
    end

    def status=(status)
      LIGHTS.keys.each do |color|
        color_value = status[color.to_s]
        next unless color_value
        turn_on(color)  if color_value.to_i == 1
        turn_off(color) if color_value.to_i == 0
      end
      update!
    end

    def status
      out = { :multi_light_mode => multi_light_mode }
      LIGHTS.keys.each { |color| out[color] = @current_state[LIGHTS[color]] }
      out
    end

    def update!
      `#{K8055_CLI_LOCATION} -P:#{USB_ADRESS} -D:#{current_state.to_dec}`
    end

  end
end
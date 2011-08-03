module TrafficLight
  class CijoeBuildStatus

    attr_reader :status

    BUILDING_BODY = 'building'

    STATUS_COLORS = {
      :worked =>    :green,
      :building =>  :yellow,
      :failed =>    :red
    }

    def initialize(traffic_light, options = {})
      @traffic_light =      traffic_light
      @base_url =           options["base_url"]
      @http_auth_user =     options["http_auth_user"]
      @http_auth_password = options["http_auth_password"]

      watch
    end

    def ping
      url = URI.parse("#{@base_url}/ping")
      request = Net::HTTP::Get.new(url.path)

      request.basic_auth @http_auth_user, @http_auth_password if @http_auth_user && @http_auth_password
      response = Net::HTTP.start(url.host, url.port) {|http| http.request(request) }

      old_status = @status
      @status = determine_status(response)

      propagate_new_status(@status) unless @status == old_status
      @status
    end

    def watch(sleep_time = 10)
      @watcher = Thread.new(sleep_time) do |args|
        until false do
          ping
          sleep sleep_time
        end
      end
      @watcher.join
    end

    def unwatch
      @watcher.exit
    end

    private

    def propagate_new_status(status)
      return @traffic_light.log "CI JOE WATCHER ERROR" if status == :error

      @traffic_light.log "New CiJoe Status: #{status}"
      @traffic_light.multi_light_mode = false
      @traffic_light.turn_on!(STATUS_COLORS[status])
    end

    def determine_status(response)
      return :worked if response.code == '200'

      if response.code == '412'
        return :building if response.body == BUILDING_BODY
        return :failed
      end

      :error
    end
  end
end
module TrafficLight
  class DigitalOutput

    include Enumerable

    BIT_SIZE = 8

    def initialize()
      setup_bits
    end

    def size
      @bits.size
    end

    def []=(position, value)
      @bits[position] = value
    end

    # Read a bit (1/0)
    def [](position)
      @bits[position]
    end

    # Iterate over each bit
    def each(&block)
      rtl = @bits.reverse
      size.times { |position| yield rtl[position] }
    end

    def to_s
      inject("") { |a, b| a + b.to_s }
    end

    def to_dec
      Integer("0b" + self.to_s)
    end

    def reset!
      setup_bits
    end

    private

    def setup_bits
      @bits = Array.new(BIT_SIZE) {0}
    end

  end
end
module Progenitor
  class Sequence

    def initialize(start=0)
      @lock = Mutex.new
      @current = start
    end

    def next_int
      @lock.synchronize do
        value = @current
        @current += 1
        value
      end
    end

    def in_sequence(&block)
      value = next_int
      block.call value
    end

    private
    attr_reader :lock # here to be accessed via #send for testing purposes

  end
end
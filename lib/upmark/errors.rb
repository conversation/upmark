module Upmark
  class ParseFailed < StandardError

    def initialize(message, cause)
      @cause = cause
      super(message)
    end

    def cause
      @cause
    end

  end
end

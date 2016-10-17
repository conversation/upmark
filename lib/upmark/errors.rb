module Upmark
  class ParseFailed < StandardError
    attr_reader :cause

    def initialize(message, cause)
      @cause = cause
      super(message)
    end

    def ascii_tree
      @cause && @cause.ascii_tree
    end
  end
end

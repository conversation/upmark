require "rubygems"
require "bundler/setup"

require "parslet"

require "upmark/parser"
require "upmark/transform"
require "upmark/version"

module Upmark
  def self.convert(html)
    parser    = Parser.new
    transform = Transform.new

    ast    = parser.parse(html.strip)
    result = transform.apply(ast)

    # The result is either a String or an Array.
    result = result.join if result.is_a?(Array)

    # Any more than two consecutive newline characters is superflous.
    result = result.gsub(/\n(\s*\n)+/, "\n\n")

    pp ast
    pp result

    result.strip
  end
end

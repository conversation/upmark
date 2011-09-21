require "parslet"

require "upmark/parser"
require "upmark/transform"
require "upmark/version"

module Upmark
  def self.convert(html)
    parser    = Parser.new
    transform = Transform.new
    ast = parser.parse(html)
    pp ast
    result = transform.apply(ast)
    pp result
    result = result.join if result.is_a?(Array)
    result
  end
end

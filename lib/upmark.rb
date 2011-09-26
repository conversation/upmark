require "parslet"

require "core_ext/array"

require "upmark/parser/xml"
require 'upmark/transform_helpers'
require "upmark/transform/markdown"
require "upmark/transform/normalise"
require "upmark/transform/preprocess"
require "upmark/version"

module Upmark
  def self.convert(html)
    xml          = Parser::XML.new
    normalise    = Transform::Normalise.new
    preprocess   = Transform::Preprocess.new
    markdown     = Transform::Markdown.new

    ast = xml.parse(html.strip)
    ast = normalise.apply(ast)
    ast = preprocess.apply(ast)
    ast = markdown.apply(ast)

    # The result is either a String or an Array.
    ast = ast.join if ast.is_a?(Array)

    # Any more than two consecutive newline characters is superflous.
    ast = ast.gsub(/\n(\s*\n)+/, "\n\n")

    ast.strip
  end
end

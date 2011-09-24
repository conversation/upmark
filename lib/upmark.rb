require "parslet"

require "core_ext/array"

require "upmark/parser/xml"
require 'upmark/transform_helpers'
require "upmark/transform/markdown"
require "upmark/transform/pass_through"
require "upmark/transform/preprocess"
require "upmark/version"

module Upmark
  def self.convert(html)
    xml          = Parser::XML.new
    preprocess   = Transform::Preprocess.new
    pass_through = Transform::PassThrough.new
    markdown     = Transform::Markdown.new

    ast = xml.parse(html.strip)
    ast = preprocess.apply(ast)
    ast = pass_through.apply(ast)
    ast = markdown.apply(ast)

    # The result is either a String or an Array.
    ast = ast.join if ast.is_a?(Array)

    # Any more than two consecutive newline characters is superflous.
    ast = ast.gsub(/\n(\s*\n)+/, "\n\n")

    ast.strip
  end
end

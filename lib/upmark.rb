require "parslet"

require 'upmark/errors'
require "upmark/parser/xml"
require 'upmark/transform_helpers'
require "upmark/transform/markdown"
require "upmark/transform/normalise"
require "upmark/transform/preprocess"

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

    # Remove trailing whitespace
    ast.gsub!(/ +$/,'')

    # Compress bullet point lists
    ast.gsub!(/^•\s*([^•\n]*)\n+(?=•)/,"* #{'\1'}\n")

    # Any more than two consecutive newline characters is superflous.
    ast.gsub!(/\n(\s*\n)+/, "\n\n")

    # Remove other bullet points
    ast.gsub!(/^•\s*/,"* ")

    ast.strip
  rescue Parslet::ParseFailed => e
    raise Upmark::ParseFailed.new('Parse failed', e)
  end
end

require "parslet"

require "core_ext/array"

require "upmark/markdown_transform"
require "upmark/preprocess_transform"
require "upmark/version"
require "upmark/xml_parser"

module Upmark
  def self.convert(html)
    parser     = XMLParser.new
    preprocess = PreprocessTransform.new
    markdown   = MarkdownTransform.new

    ast = parser.parse(html.strip)
    ast = preprocess.apply(ast)
    ast = markdown.apply(ast)

    # The result is either a String or an Array.
    ast = ast.join if ast.is_a?(Array)

    # Any more than two consecutive newline characters is superflous.
    ast = ast.gsub(/\n(\s*\n)+/, "\n\n")

    ast.strip
  end
end

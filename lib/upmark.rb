require "parslet"

require "core_ext/array"

require "upmark/markdown_transform"
require "upmark/version"
require "upmark/xml_parser"

module Upmark
  def self.convert(html)
    parser    = XMLParser.new
    transform = MarkdownTransform.new

    ast    = parser.parse(html.strip)
    result = transform.apply(ast)

    # The result is either a String or an Array.
    result = result.join if result.is_a?(Array)

    # Any more than two consecutive newline characters is superflous.
    result = result.gsub(/\n(\s*\n)+/, "\n\n")

    result.strip
  end
end

require "upmark/transform/ignore"

module Upmark
  module Transform
    # A transform class which marks block-level elements as ignored.
    # i.e. These elements should not be converted to Markdown.
    class Preprocess < Parslet::Transform
      include TransformHelpers

      element(:div, :table, :pre) do |element|
        {
          element: {
            name:       element[:name],
            attributes: element[:attributes],
            children:   Ignore.new.apply(element[:children]),
            ignore:     true
          }
        }
      end
    end
  end
end

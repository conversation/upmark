require "upmark/transform/ignore"

module Upmark
  module Transform
    class PassThrough < Parslet::Transform
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

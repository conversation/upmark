module Upmark
  module Transform
    # A transform class which marks all elements in a subtree as ignored.
    class Ignore < Parslet::Transform
      include TransformHelpers

      element(:*) do |element|
        {
          element: {
            name:       element[:name],
            attributes: element[:attributes],
            children:   element[:children],
            ignore:     true
          }
        }
      end
    end
  end
end

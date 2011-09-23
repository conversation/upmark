module Upmark
  module Transform
    # A transform class which marks all elements as ignored in a subtree.
    class Ignore < Parslet::Transform
      rule(
        element: {
          tag:     {name: simple(:tag_name), attributes: subtree(:attributes)},
          content: subtree(:values)
        }
      ) do
        {
          element: {
            tag:     {name: tag_name, attributes: attributes},
            content: PassThrough.new.apply(self.values),
            ignore:  true
          }
        }
      end
    end
  end
end

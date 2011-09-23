module Upmark
  module Transform
    class PassThrough < Parslet::Transform
      rule(
        element: {
          tag:     {name: "table", attributes: subtree(:attributes)},
          content: subtree(:values)
        }
      ) do
        {
          element: {
            tag:     {name: "table", attributes: attributes},
            content: Ignore.new.apply(self.values)
          }
        }
      end
    end
  end
end

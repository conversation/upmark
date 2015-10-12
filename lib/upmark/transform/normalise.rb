module Upmark
  module Transform
    # A transform class withich normalises start/end/empty tags into the
    # same structure.
    class Normalise < Parslet::Transform

      rule(element: subtree(:invalid)) do
        raise Upmark::ParseFailed
      end

      rule(
        element: {
          start_tag: {name: simple(:name), attributes: subtree(:attributes)},
          end_tag:   {name: simple(:end_tag_name)},
          children:  subtree(:children)
        }
      ) do
        raise Upmark::ParseFailed unless name == end_tag_name
        {
          element: {
            name:       name,
            attributes: attributes,
            children:   children,
            ignore:     false
          }
        }
      end

      rule(
        element: {
          empty_tag: {name: simple(:name), attributes: subtree(:attributes)}
        }
      ) do
        {
          element: {
            name:       name,
            attributes: attributes,
            children:   [],
            ignore:     false
          }
        }
      end

    end
  end
end

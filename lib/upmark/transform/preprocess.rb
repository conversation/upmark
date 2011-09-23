module Upmark
  module Transform
    class Preprocess < Parslet::Transform
      rule(
        start_tag: {name: simple(:tag_name), attributes: subtree(:attributes)},
        end_tag:   {name: simple(:tag_name)},
        content:   subtree(:values)
      ) do
        {
          tag:     {name: tag_name, attributes: attributes},
          content: values
        }
      end

      rule(
        empty_tag: {name: simple(:tag_name), attributes: subtree(:attributes)}
      ) do
        {
          tag:     {name: tag_name, attributes: attributes},
          content: []
        }
      end
    end
  end
end

module Upmark
  class Transform < Parslet::Transform
    rule(
      element: subtree(:value)
    ) { value }

    rule(
      start_tag: {name: "p", attributes: subtree(:attributes)},
      end_tag:   {name: "p"},
      content:   sequence(:values)
    ) { values.join + "\n\n" }

    rule(
      start_tag: {name: "strong", attributes: subtree(:attributes)},
      end_tag:   {name: "strong"},
      content:   sequence(:values)
    ) { "**#{values.join}**" }

    rule(
      start_tag: {name: "em", attributes: subtree(:attributes)},
      end_tag:   {name: "em"},
      content:   sequence(:values)
    ) { "*#{values.join}*" }

    rule(
      start_tag: {name: "a", attributes: subtree(:attributes)},
      end_tag:   {name: "a"},
      content:   sequence(:values)
    ) do
      attributes = self.attributes.inject({}) {|hash, attribute| hash[attribute[:name].to_sym] = attribute[:value]; hash }

      href  = attributes[:href]
      title = attributes[:title]

      %Q{[#{values.join}](#{href} "#{title}")}
    end

    rule(
      text: simple(:value)
    ) { value }
  end
end

module Upmark
  class Transform < Parslet::Transform
    rule(
      node: subtree(:value)
    ) { value }

    rule(
      start_tag: {name: "p"},
      end_tag:   {name: "p"},
      content:   simple(:value)
    ) { "#{value}\n\n" }

    rule(
      start_tag: {name: "p"},
      end_tag:   {name: "p"},
      content:   sequence(:values)
    ) { values.join + "\n\n" }

    rule(
      start_tag: {name: "strong"},
      end_tag:   {name: "strong"},
      content:   simple(:value)
    ) { "**#{value}**" }

    rule(
      text: simple(:value)
    ) { value.to_s.strip }
  end
end

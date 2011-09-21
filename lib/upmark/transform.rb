module Upmark
  class Transform < Parslet::Transform
    rule(
      element: subtree(:value)
    ) { value }

    rule(
      start_tag: {name: "p"},
      end_tag:   {name: "p"},
      content:   sequence(:values)
    ) { values.join + "\n\n" }

    rule(
      start_tag: {name: "strong"},
      end_tag:   {name: "strong"},
      content:   sequence(:values)
    ) { "**#{values.join}**" }

    rule(
      start_tag: {name: "em"},
      end_tag:   {name: "em"},
      content:   sequence(:values)
    ) { "*#{values.join}*" }

    rule(
      start_tag: {name: "a"},
      end_tag:   {name: "a"},
      content:   sequence(:values)
    ) { "[#{values.join}]" }

    rule(
      text: simple(:value)
    ) { value }
  end
end

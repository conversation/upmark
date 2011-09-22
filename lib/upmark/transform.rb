module Upmark
  class Transform < Parslet::Transform
    def self.tag(name)
      {
        start_tag: {name: name.to_s, attributes: subtree(:attributes)},
        end_tag:   {name: name.to_s},
        content:   sequence(:values)
      }
    end

    def self.map_attributes_subtree(ast)
      ast.inject({}) do |hash, attribute|
        hash[attribute[:name].to_sym] = attribute[:value]
        hash
      end
    end

    rule(element: subtree(:value)) { value }

    rule(text: simple(:value)) { value }

    rule(
      start_tag: {name: "ul", attributes: subtree(:attributes)},
      end_tag:   {name: "ul"},
      content:   subtree(:value)
    ) { value }

    rule(tag(:p))      { "#{values.join}\n\n" }
    rule(tag(:strong)) { "**#{values.join}**" }
    rule(tag(:em))     { "*#{values.join}*" }
    rule(tag(:li))     { "* #{values.join}" }

    rule(tag(:a)) do |dictionary|
      attributes = map_attributes_subtree(dictionary[:attributes])

      values = dictionary[:values].join
      href   = attributes[:href]
      title  = attributes[:title]

      %Q{[#{values}](#{href} "#{title}")}
    end
  end
end

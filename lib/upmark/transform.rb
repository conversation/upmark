require "core_ext/array"

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

    rule(element: subtree(:values)) { values }

    rule(text: simple(:value)) { value.to_s }

    rule(tag(:ul)) do |dictionary|
      values = dictionary[:values].map {|value| value.strip != "" ? value : nil }.compact
      values.map {|value| "* #{value}\n" }
    end

    rule(tag(:ol)) do |dictionary|
      values = dictionary[:values].map {|value| value.strip != "" ? value : nil }.compact
      values.map_with_index {|value, i| "#{i + 1}. #{value}\n" }
    end

    rule(tag(:a)) do |dictionary|
      attributes = map_attributes_subtree(dictionary[:attributes])

      values = dictionary[:values].join
      href   = attributes[:href]
      title  = attributes[:title]

      %Q{[#{values}](#{href} "#{title}")}
    end

    rule(tag(:p))      { "#{values.join}\n\n" }
    rule(tag(:strong)) { "**#{values.join}**" }
    rule(tag(:em))     { "*#{values.join}*" }
    rule(tag(:li))     { "#{values.join}" }
  end
end

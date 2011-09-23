module Upmark
  module Transform
    # The Markdown transform class.
    #
    # Transforms an abstract syntax tree (AST) into a Markdown document.
    #
    class Markdown < Parslet::Transform
      def self.tag(tag_name)
        tag_name = tag_name.to_s.downcase
        {
          tag:     {name: tag_name, attributes: subtree(:attributes)},
          content: sequence(:values)
        }
      end

      def self.map_attributes_subtree(ast)
        ast.inject({}) do |hash, attribute|
          hash[attribute[:name].to_sym] = attribute[:value]
          hash
        end
      end

      rule(
        tag:     {name: simple(:tag_name), attributes: subtree(:attributes)},
        content: subtree(:values),
        ignore: true
      ) do |dictionary|
        attributes = map_attributes_subtree(dictionary[:attributes])
        values     = dictionary[:values].join
        tag_name   = dictionary[:tag_name]

        attributes_list =
          if attributes.any?
            " " + attributes.map {|name, value| %Q{#{name}="#{value}"} }.join(" ")
          else
            ""
          end

        %Q{<#{tag_name}#{attributes_list}>#{values}</#{tag_name}>}
      end

      rule(element: subtree(:values)) { values }

      rule(text: simple(:value)) { value.to_s }

      rule(tag(:p))      { "#{values.join}\n\n" }
      rule(tag(:strong)) { "**#{values.join}**" }
      rule(tag(:em))     { "*#{values.join}*" }
      rule(tag(:li))     { "#{values.join}" }
      rule(tag(:h1))     { "# #{values.join}" }
      rule(tag(:h2))     { "## #{values.join}" }
      rule(tag(:h3))     { "### #{values.join}" }
      rule(tag(:br))     { "\n" }

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
        href       = attributes[:href]
        title      = attributes[:title]
        values     = dictionary[:values].join

        %Q{[#{values}](#{href} "#{title}")}
      end

      rule(tag(:img)) do |dictionary|
        attributes = map_attributes_subtree(dictionary[:attributes])
        href       = attributes[:src]
        title      = attributes[:title]
        alt_text   = attributes[:alt]

        %Q{![#{alt_text}](#{href} "#{title}")}
      end

      # Catch-all rule to pass all tags through.
      rule(
        tag:     {name: simple(:tag_name), attributes: subtree(:attributes)},
        content: sequence(:values)
      ) do |dictionary|
        attributes = map_attributes_subtree(dictionary[:attributes])
        values     = dictionary[:values].join
        tag_name   = dictionary[:tag_name]

        attributes_list =
          if attributes.any?
            " " + attributes.map {|name, value| %Q{#{name}="#{value}"} }.join(" ")
          else
            ""
          end

        %Q{<#{tag_name}#{attributes_list}>#{values}</#{tag_name}>}
      end
    end
  end
end
module Upmark
  module Transform
    # A transform class which converts an abstract syntax tree (AST) into
    # a Markdown document.
    class Markdown < Parslet::Transform
      include TransformHelpers

      rule(text: simple(:value)) { value.to_s }

      element(:p)  {|element| "#{element[:children].join}\n\n" }
      element(:h1) {|element| "# #{element[:children].join}" }
      element(:h2) {|element| "## #{element[:children].join}" }
      element(:h3) {|element| "### #{element[:children].join}" }
      element(:li) {|element| "#{element[:children].join}" }

      element(:ul) do |element|
        children = element[:children].map {|value| value.strip != "" ? value : nil }.compact
        children.map {|value| "* #{value}\n" }
      end

      element(:ol) do |element|
        children = element[:children].map {|value| value.strip != "" ? value : nil }.compact
        children.map_with_index {|value, i| "#{i + 1}. #{value}\n" }
      end

      element(:a) do |element|
        attributes = map_attributes_subtree(element[:attributes])
        href       = attributes[:href]
        title      = attributes[:title]
        children   = element[:children].join

        %Q{[#{children}](#{href} "#{title}")}
      end

      element(:img) do |element|
        attributes = map_attributes_subtree(element[:attributes])
        href       = attributes[:src]
        title      = attributes[:title]
        alt_text   = attributes[:alt]

        %Q{![#{alt_text}](#{href} "#{title}")}
      end

      element(:b, :strong) {|element| "**#{element[:children].join}**" }
      element(:i, :em)     {|element| "*#{element[:children].join}*" }

      element(:br) { "\n" }

      # Pass all unmatched elements through.
      rule(
        element: {
          name:       simple(:name),
          attributes: subtree(:attributes),
          children:   sequence(:children),
          ignore:     simple(:ignore)
        }
      ) do |element|
        attributes = map_attributes_subtree(element[:attributes])
        children    = element[:children].join
        name       = element[:name]

        attributes_list =
          if attributes.any?
            " " + attributes.map {|name, value| %Q{#{name}="#{value}"} }.join(" ")
          else
            ""
          end

        if children.empty?
          %Q{<#{name}#{attributes_list} />}
        else
          %Q{<#{name}#{attributes_list}>#{children}</#{name}>}
        end
      end
    end
  end
end

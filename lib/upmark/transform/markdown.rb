module Upmark
  module Transform
    # A transform class which converts an abstract syntax tree (AST) into
    # a Markdown document.
    class Markdown < Parslet::Transform
      include TransformHelpers

      rule(text: simple(:value)) { value.to_s }

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
        children   = element[:children].join
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

      def self.text(element)
        element[:children].join.gsub(/(\n)[\n ]+/, '\1')
      end

      element(:p)  {|element| "#{text(element)}\n\n" }
      element(:h1) {|element| "# #{text(element)}" }
      element(:h2) {|element| "## #{text(element)}" }
      element(:h3) {|element| "### #{text(element)}" }
      element(:h4) {|element| "#### #{text(element)}" }
      element(:h5) {|element| "##### #{text(element)}" }
      element(:h6) {|element| "###### #{text(element)}" }
      element(:li) {|element| "#{text(element)}" }

      element(:ul) do |element|
        children = element[:children].flatten.map {|value| value.strip != "" ? value : nil }.compact
        children.map {|value| "* #{value.gsub(/^\s*•\s*/,'')}\n" }
      end

      element(:ol) do |element|
        children = element[:children].flatten.map {|value| value.strip != "" ? value : nil }.compact
        children.map.with_index {|value, i| "#{i + 1}. #{value}\n" }
      end

      element(:a) do |element|
        attributes = map_attributes_subtree(element[:attributes])
        href       = attributes[:href]
        title      = attributes[:title]

        if /^(?:http|mailto)/ =~ href
          %Q{[#{text(element)}](#{href} "#{title}")}
        else
          text(element)
        end
      end

      element(:img) do |element|
        attributes = map_attributes_subtree(element[:attributes])
        href       = attributes[:src].to_s
        title      = attributes[:title]
        alt_text   = attributes[:alt]

        if /^http/ =~ href
          %Q{![#{alt_text}](#{href} "#{title}")}
        else
          "#{alt_text || title}"
        end
      end

      element(:b, :strong) {|element| "**#{text(element)}**" }
      element(:i, :em)     {|element| "*#{text(element)}*" }

      element(:br) { "\n" }
      rule(element: { name: "br"}) { "\n" }

    end
  end
end

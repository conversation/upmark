require "upmark/transform/ignore"

module Upmark
  module Transform
    # A transform class which marks block-level elements as ignored.
    # i.e. These elements should not be converted to Markdown.
    class Preprocess < Parslet::Transform
      include TransformHelpers

      element(:div, :pre) do |element|
        {
          element: {
            name:       element[:name],
            attributes: element[:attributes],
            children:   Ignore.new.apply(element[:children]),
            ignore:     true
          }
        }
      end

      element(:span) do |element|
        element[:children]
      end

      # table content elements are stripped ignoring their spacing
      element(:table, :thead, :tbody, :tfoot) do |element|
        element[:children].reject! do |c|
          Hash === c && c[:text].to_s =~ /\A[\n ]*\Z/m
        end
        element[:children]
      end

      # table content elements are stripped
      element(:td, :th) do |element|
        element[:children]
      end

      # table rows are treated as 'paragraph' blocks
      element(:tr) do |element|
        element[:children]
          .select { |c| Array === c }
          .map do |children|
            children.map do |child|
              if child[:text]
                child[:text].to_s.gsub!(/^\n */,'')
              end
              child
            end + ["\n"]
          end + ["\n"]
      end
    end
  end
end

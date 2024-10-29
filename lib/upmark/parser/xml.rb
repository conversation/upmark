module Upmark
  module Parser
    # The XML parser class.
    #
    # Parses a XML document into an abstract syntax tree (AST).
    #
    # It's worth referring to the XML spec:
    #   http://www.w3.org/TR/2000/REC-xml-20001006
    #
    class XML < Parslet::Parser
      root(:node)

      rule(:node) do
        (
          empty_element.as(:empty) |
          element.as(:element) |
          text.as(:text)
        ).repeat(0)
      end

      rule(:empty_element) do
        start_tag.as(:start_tag) >>
        match(/\s+/) >>
        end_tag.as(:end_tag)
      end

      rule(:element) do
        empty_br.as(:empty_tag) |
        (
          start_tag.as(:start_tag) >>
          node.as(:children) >>
          end_tag.as(:end_tag)
        ) |
        empty_tag.as(:empty_tag)
      end

      rule(:text) do
        match(/\A[\s\n\t ]+\Z/m).absent? >> # ignore entirely empty strings
        match(/[^<]/).repeat(1)
      end

      rule(:start_tag) do
        str('<') >>
        name.as(:name) >>
        (space >> attribute).repeat.as(:attributes) >>
        space? >>
        str('>')
      end

      rule(:end_tag) do
        str('</') >>
        name.as(:name) >>
        space? >>
        str('>')
      end

      rule(:empty_br) do
        str('<') >> space? >> str('br').as(:name) >> space? >> str('>')
      end

      rule(:empty_tag) do
        str('<') >>
        name.as(:name) >>
        (space >> attribute).repeat.as(:attributes) >>
        space? >>
        str('/>')
      end

      rule(:name) do
        match(/[a-zA-Z_:]/) >> match(/[\w:\.-]/).repeat
      end

      rule(:attribute) do
        name.as(:name) >>
        str('=') >> (
          (str('"') >> double_quoted_attribute_value.as(:value) >> str('"')) | # double quotes
          (str("'") >> single_quoted_attribute_value.as(:value) >> str("'"))   # single quotes
        )
      end

      rule(:double_quoted_attribute_value) do
        (str('"').absent? >> (match(/[^<]/) | string_entity | numeric_entity)).repeat
      end

      rule(:single_quoted_attribute_value) do
        (str("'").absent? >> (match(/[^<]/) | string_entity | numeric_entity)).repeat
      end

      rule(:string_entity) { match("&") >> name >> match(";") }
      rule(:numeric_entity) { match(/&#\d+;/) }

      rule(:space)  { match(/\s/).repeat(1) }
      rule(:space?) { space.maybe }
    end
  end
end

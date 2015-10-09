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
          element.as(:element) |
          text.as(:text)
        ).repeat(0)
      end

      rule(:element) do
        (
          start_tag.as(:start_tag) >>
          node.as(:children) >>
          end_tag.as(:end_tag)
        ) |
        empty_tag.as(:empty_tag)
      end

      rule(:text) do
        match(/[^<>]/).repeat(1)
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
        (str('"').absent? >> (match(/[^<&]/) | entity_ref)).repeat
      end

      rule(:single_quoted_attribute_value) do
        (str("'").absent? >> (match(/[^<&]/) | entity_ref)).repeat
      end

      rule(:entity_ref) { match("&") >> name >> match(";") }

      rule(:space)  { match(/\s/).repeat(1) }
      rule(:space?) { space.maybe }
    end
  end
end

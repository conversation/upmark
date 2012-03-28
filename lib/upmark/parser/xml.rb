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

      rule(:node) {
        (
          element.as(:element) |
          text.as(:text)
        ).repeat(0)
      }

      rule(:element) {
        (
          start_tag.as(:start_tag) >>
          node.as(:children) >>
          end_tag.as(:end_tag)
        ) |
        empty_tag.as(:empty_tag)
      }

      rule(:text) {
        match(/[^<>]/).repeat(1)
      }

      rule(:start_tag) {
        str('<') >>
        name.as(:name) >>
        (space >> attribute).repeat.as(:attributes) >>
        space? >>
        str('>')
      }

      rule(:end_tag) {
        str('</') >>
        name.as(:name) >>
        space? >>
        str('>')
      }

      rule(:empty_tag) {
        str('<') >>
        name.as(:name) >>
        (space >> attribute).repeat.as(:attributes) >>
        space? >>
        str('/>')
      }

      rule(:name) {
        match(/[a-zA-Z_:]/) >> match(/[\w:\.-]/).repeat
      }

      rule(:attribute) {
        name.as(:name) >>
        str('=') >> (
          (str('"') >> attribute_value.as(:value) >> str('"')) | # double quotes
          (str("'") >> attribute_value.as(:value) >> str("'"))   # single quotes
        )
      }

      rule(:attribute_value) {
        (match(/['"]/).absent? >> (match(/[^<&]/) | entity_ref)).repeat
      }

      rule(:entity_ref) { match("&") >> name >> match(";") }

      rule(:space)  { match(/\s/).repeat(1) }
      rule(:space?) { space.maybe }
    end
  end
end

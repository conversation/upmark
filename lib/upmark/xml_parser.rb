module Upmark
  # The XML parser class.
  #
  # Parses a XML document fragment into an abstract syntax tree (AST).
  #
  # It's worth referring to the XML spec:
  #   http://www.w3.org/TR/2000/REC-xml-20001006
  #
  class XMLParser < Parslet::Parser
    root(:content)

    rule(:content) {
      (
        element.as(:element) |
        text.as(:text)
      ).repeat(0)
    }

    rule(:element) {
      start_tag.as(:start_tag) >>
      content.as(:content) >>
      end_tag.as(:end_tag)
    }

    rule(:text) {
      match(/[^<>]/).repeat(1)
    }

    rule(:start_tag) {
      str('<') >>
      name.as(:name) >>
      (space >> attribute).repeat.as(:attributes) >>
      str('>')
    }

    rule(:end_tag) {
      str('</') >>
      name.as(:name) >>
      str('>')
    }

    rule(:name) {
      match(/[a-zA-Z_:]/) >> match(/[\w:\.-]/).repeat
    }

    rule(:attribute) {
      name.as(:name) >>
      str('=') >>
      match(/['"]/) >>
      attribute_value.as(:value) >>
      match(/['"]/)
    }

    rule(:attribute_value) {
      (match(/['"]/).absent? >> match(/[^<&]/)).repeat
    }

    rule(:space) { match(/\s/).repeat(1) }
  end
end

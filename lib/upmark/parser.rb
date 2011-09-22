module Upmark
  class Parser < Parslet::Parser
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
      tag_name.as(:name) >>
      (space >> attribute).repeat.as(:attributes) >>
      str('>')
    }

    rule(:end_tag) {
      str('</') >>
      tag_name.as(:name) >>
      str('>')
    }

    rule(:tag_name) {
      (
        str('>').absent? >>
        match(/[a-zA-Z]/)
      ).repeat(1)
    }

    rule(:attribute) {
      attribute_name.as(:name) >>
      str('=') >>
      match(/['"]/) >>
      attribute_value.as(:value) >>
      match(/['"]/)
    }

    rule(:attribute_name) {
      match(/[a-zA-Z_:]/) >> (
        str('=').absent? >>
        match(/[\w:\.-]/)
      ).repeat
    }

    rule(:attribute_value) {
      (match(/['"]/).absent? >> match(/[^%&]/)).repeat
    }

    rule(:space) { match('\s').repeat(1) }
  end
end

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
      match('[^<>]').repeat(1)
    }

    rule(:start_tag) {
      str('<') >>
      (
        str('>').absent? >>
        match("[a-zA-Z]")
      ).repeat(1).as(:name) >>
      (space >> attribute).repeat(0).as(:attributes) >>
      str('>')
    }

    rule(:attribute) {
      (
        str('=').absent? >> any
      ).repeat(1).as(:name) >>
      str('=') >>
      (
        match(/['"]/) >>
        (match(/['"]/).absent? >> any).repeat.as(:value) >>
        match(/['"]/)
      )
    }

    rule(:end_tag) {
      str('</') >>
      (
        str('>').absent? >>
        match("[a-zA-Z]")
      ).repeat(1).as(:name) >>
      str('>')
    }

    rule(:space) { match('\s').repeat(1) }
  end
end

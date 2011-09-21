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
      tag(close: false).as(:start_tag) >>
      content.as(:content) >>
      tag(close: true).as(:end_tag)
    }

    rule(:text) {
      match('[^<>]').repeat(1)
    }

    def tag(options = {})
      parslet = str('<')
      parslet = parslet >> str('/') if options[:close]
      parslet = parslet >> (str('>').absent? >> match("[a-zA-Z]")).repeat(1).as(:name)
      parslet = parslet >> str('>')
      parslet
    end
  end
end

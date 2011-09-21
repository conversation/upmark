module Upmark
  class Parser < Parslet::Parser
    root(:content)

    rule(:node) {
      element.repeat(0).as(:node)
    }

    rule(:element) {
      tag(close: false).as(:start_tag) >> content.as(:content) >> tag(close: true).as(:end_tag)
    }

    rule(:content) {
      text.maybe >> (
        element >>
        text.maybe
      ).repeat(0)
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

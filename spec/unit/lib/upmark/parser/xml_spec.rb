RSpec.describe Upmark::Parser::XML do
  let(:parser) { Upmark::Parser::XML.new }

  context "#node" do
    it 'will parse ""' do
      expect(parser.node).to parse ""
    end
    it 'will parse "messenger bag skateboard"' do
      expect(parser.node).to parse "messenger bag skateboard"
    end
    it 'will parse html br tags' do
      expect(parser.node).to parse '<p>One<br>Two</p>'
    end
    it 'will parse "<p>messenger bag skateboard</p>"' do
      expect(
        parser.node
      ).to parse "<p>messenger bag skateboard</p>"
    end
    it 'will parse "messenger <p>bag</p> skateboard"' do
      expect(
        parser.node
      ).to parse "messenger <p>bag</p> skateboard"
    end
    it 'will parse "<p>messenger</p><p>bag</p><p>skateboard</p>"' do
      expect(
        parser.node
      ).to parse "<p>messenger</p><p>bag</p><p>skateboard</p>"
    end
    it 'will parse "<p>messenger</p>\n<p>bag</p>\n<p>skateboard</p>"' do
      expect(
        parser.node
      ).to parse "<p>messenger</p>\n<p>bag</p>\n<p>skateboard</p>"
    end
    it 'will parse "<p>messenger <strong>bag</strong> skateboard</p>"' do
      expect(
        parser.node
      ).to parse "<p>messenger <strong>bag</strong> skateboard</p>"
    end
  end

  context "#element" do
    it 'will parse "<p></p>"' do
      expect(parser.element).to parse "<p></p>"
    end
    it 'will parse "<p>messenger bag skateboard</p>"' do
      expect(parser.element).to parse "<p>messenger bag skateboard</p>"
    end
    it 'will parse "<p>Some<br>Text</p>"' do
      expect(parser.element).to parse "<p>Some<br>Text</p>"
    end
    it 'will parse %q{<tofu art="party" />}' do
      expect(parser.element).to parse %q{<tofu art="party" />}
    end
    it 'will not parse "<p>"' do
      expect(parser.element).to_not parse "<p>"
    end
    it 'will not parse "<p>messenger bag skateboard"' do
      expect(parser.element).to_not parse "<p>messenger bag skateboard"
    end
    it 'will not parse "messenger bag skateboard</p>"' do
      expect(parser.element).to_not parse "messenger bag skateboard</p>"
    end
    it 'will not parse "<p>messenger bag skateboard<p>"' do
      expect(parser.element).to_not parse "<p>messenger bag skateboard<p>"
    end
  end

  context "#text" do
    it 'will parse "messenger bag skateboard"' do
      expect(parser.text).to parse "messenger bag skateboard"
    end
    it 'will not parse "<p>messenger bag skateboard</p>"' do
      expect(parser.text).to_not parse "<p>messenger bag skateboard</p>"
    end
    it 'will not parse ""' do
      expect(parser.text).to_not parse ""
    end
  end

  context "#start_tag" do
    it 'will parse %q{<tofu art="party">}' do
      expect(parser.start_tag).to parse %q{<tofu art="party">}
    end
    it 'will parse %q{<tofu art="party" synth="letterpress">}' do
      expect(parser.start_tag).to parse %q{<tofu art="party" synth="letterpress">}
    end
    it 'will parse "<tofu>"' do
      expect(parser.start_tag).to parse "<tofu>"
    end
    it 'will not parse "</tofu>"' do
      expect(parser.start_tag).to_not parse "</tofu>"
    end
    it 'will not parse "<tofu"' do
      expect(parser.start_tag).to_not parse "<tofu"
    end
    it 'will not parse "tofu>"' do
      expect(parser.start_tag).to_not parse "tofu>"
    end
  end

  context "#end_tag" do
    it 'will parse "</tofu>"' do
      expect(parser.end_tag).to parse "</tofu>"
    end
    it 'will not parse "<tofu>"' do
      expect(parser.end_tag).to_not parse "<tofu>"
    end
    it 'will not parse "<tofu"' do
      expect(parser.end_tag).to_not parse "<tofu"
    end
    it 'will not parse "/tofu>"' do
      expect(parser.end_tag).to_not parse "/tofu>"
    end
  end

  context "#empty_br" do
    it 'will parse html br tags' do
      expect(parser.empty_br).to parse '<br>'
    end
  end

  context "#empty_tag" do
    it 'will parse %q{<tofu />}' do
      expect(parser.empty_tag).to parse %q{<tofu />}
    end
    it 'will parse %q{<tofu art="party" />}' do
      expect(parser.empty_tag).to parse %q{<tofu art="party" />}
    end
    it 'will parse %q{<tofu art="party" synth="letterpress" />}' do
      expect(parser.empty_tag).to parse %q{<tofu art="party" synth="letterpress" />}
    end
    it 'will not parse "<tofu>"' do
      expect(parser.empty_tag).to_not parse "<tofu>"
    end
    it 'will not parse "</tofu>"' do
      expect(parser.empty_tag).to_not parse "</tofu>"
    end
    it 'will not parse "<tofu"' do
      expect(parser.empty_tag).to_not parse "<tofu"
    end
    it 'will not parse "/tofu>"' do
      expect(parser.empty_tag).to_not parse "/tofu>"
    end
  end

  context "#name" do
    it 'will parse "p"' do
      expect(parser.name).to parse "p"
    end
    it 'will parse "h1"' do
      expect(parser.name).to parse "h1"
    end
    it 'will not parse "1h"' do
      expect(parser.name).to_not parse "1h"
    end
    it 'will not parse "h 1"' do
      expect(parser.name).to_not parse "h 1"
    end
  end

  context "#attribute" do
    it 'will parse %q{art="party organic"}' do
      expect(parser.attribute).to parse %q{art="party organic"}
    end
    it 'will parse %q{art=\'party organic\'}' do
      expect(parser.attribute).to parse %q{art='party organic'}
    end
    it 'will parse %q{art="party\'organic"}' do
      expect(parser.attribute).to parse %q{art="party'organic"}
    end
    it 'will parse %q{art=\'party"organic\'}' do
      expect(parser.attribute).to parse %q{art='party"organic'}
    end
    it 'will not parse "art"' do
      expect(parser.attribute).to_not parse "art"
    end
    it 'will not parse "art="' do
      expect(parser.attribute).to_not parse "art="
    end
    it 'will not parse "art=party"' do
      expect(parser.attribute).to_not parse "art=party"
    end
    it 'will not parse %q{="party organic"}' do
      expect(parser.attribute).to_not parse %q{="party organic"}
    end
    it 'will not parse %q{art="party organic\'}' do
      expect(parser.attribute).to_not parse %q{art="party organic'}
    end
    it 'will not parse %q{art=\'party organic"}' do
      expect(parser.attribute).to_not parse %q{art='party organic"}
    end
  end

  context "#parse" do
    RSpec::Matchers.define :convert do |html|
      match do |parser|
        @actual = parser.parse(html)
        @actual == @expected
      end

      chain :to do |ast|
        @expected = ast
      end
      attr_reader :expected

      failure_message do
        %Q{expected "#{html}" to parse to "#{@expected.inspect}" but was #{@result.inspect}}
      end

      diffable
    end

    context "single tag" do
      it 'is parsed as a single element' do
        expect(parser).to convert("<p>messenger</p>").to([
          {
            element: {
              start_tag: {name: "p", attributes: []},
              end_tag:   {name: "p"},
              children:  [{text: "messenger"}]
            }
          }
        ])
      end
    end

    context "empty tag" do
      it 'is parsed an empty_tag element' do
        expect(parser).to convert("<br />").to([
          {
            element: {
              empty_tag: {name: "br", attributes: []}
            }
          }
        ])
      end
    end

    context "single tag with attributes" do
      let(:html) { %q{<a href="http://helvetica.com/" title="art party organic">messenger bag skateboard</a>} }

      it 'is parsed an element with an attribute subtree' do
        expect(parser).to convert(html).to([
          {
            element: {
              start_tag: {
                name: "a",
                attributes: [
                  {name: "href",  value: "http://helvetica.com/"},
                  {name: "title", value: "art party organic"}
                ]
              },
              end_tag:  {name: "a"},
              children: [{text: "messenger bag skateboard"}]
            }
          }
        ])
      end
    end

    context "multiple inline tags" do
      let(:html) { "<p>messenger</p><p>bag</p><p>skateboard</p>" }

      it 'converts to multiple elements' do
        expect(parser).to convert(html).to([
          {
            element: {
              start_tag: {name: "p", attributes: []},
              end_tag:   {name: "p"},
              children:  [{text: "messenger"}]
            }
          }, {
            element: {
              start_tag: {name: "p", attributes: []},
              end_tag:   {name: "p"},
              children:  [{text: "bag"}]
            }
          }, {
            element: {
              start_tag: {name: "p", attributes: []},
              end_tag:   {name: "p"},
              children:  [{text: "skateboard"}]
            }
          }
        ])
      end
    end

    context "multiple tags" do
      let(:html) { "<p>messenger</p>\n<p>bag</p>\n<p>skateboard</p>" }

      it 'converts to multiple elements' do
        expect(parser).to convert(html).to([
          {
            element: {
              start_tag: {name: "p", attributes: []},
              end_tag:   {name: "p"},
              children:  [{text: "messenger"}]
            }
          }, {
            text: "\n"
          }, {
            element: {
              start_tag: {name: "p", attributes: []},
              end_tag:   {name: "p"},
              children:  [{text: "bag"}]
            }
          }, {
            text: "\n"
          }, {
            element: {
              start_tag: {name: "p", attributes: []},
              end_tag:   {name: "p"},
              children:  [{text: "skateboard"}]
            }
          }
        ])
      end
    end

    context "nested tags" do
      let(:html) { "<p>messenger <strong>bag</strong> skateboard</p>" }

      it 'converts to multiple nested elements' do
        expect(parser).to convert(html).to([
          {
            element: {
              start_tag: {name: "p", attributes: []},
              end_tag:   {name: "p"},
              children:  [
                {
                  text: "messenger "
                }, {
                  element: {
                    start_tag: {name: "strong", attributes: []},
                    children:  [{text: "bag"}],
                    end_tag:   {name: "strong"}
                  }
                }, {
                  text: " skateboard"
                }
              ]
            }
          }
        ])
      end
    end
  end
end

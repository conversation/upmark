require "spec_helper"

describe Upmark::Parser do
  let(:parser) { Upmark::Parser.new }

  context "#content" do
    subject { parser.content }

    it { should parse("") }
    it { should parse("messenger bag skateboard") }
    it { should parse("<p>messenger bag skateboard</p>") }
    it { should parse("messenger <p>bag</p> skateboard") }
    it { should parse("<p>messenger</p><p>bag</p><p>skateboard</p>") }
    it { should parse("<p>messenger</p>\n<p>bag</p>\n<p>skateboard</p>") }
    it { should parse("<p>messenger <strong>bag</strong> skateboard</p>") }
  end

  context "#element" do
    subject { parser.element }

    it { should     parse("<p>messenger bag skateboard</p>") }
    it { should_not parse("<p>messenger bag skateboard") }
    it { should_not parse("messenger bag skateboard</p>") }
    it { should_not parse("<p>messenger bag skateboard<p>") }
  end

  context "#text" do
    subject { parser.text }

    it { should     parse("messenger bag skateboard") }
    it { should_not parse("<p>messenger bag skateboard</p>") }
    it { should_not parse("") }
  end

  context "#parse" do
    subject { parser.parse(html) }

    context "with multiple inline elements" do
      let(:html) { "<p>messenger</p><p>bag</p><p>skateboard</p>" }

      it do
        should == [
          {
            element: {
              start_tag: {name: "p"},
              end_tag:   {name: "p"},
              content:   [{text: "messenger"}]
            }
          }, {
            element: {
              start_tag: {name: "p"},
              end_tag:   {name: "p"},
              content:   [{text: "bag"}]
            }
          }, {
            element: {
              start_tag: {name: "p"},
              end_tag:   {name: "p"},
              content:   [{text: "skateboard"}]
            }
          }
        ]
      end
    end

    context "with multiple elements" do
      let(:html) { "<p>messenger</p>\n<p>bag</p>\n<p>skateboard</p>" }

      it do
        should == [
          {
            element: {
              start_tag: {name: "p"},
              end_tag:   {name: "p"},
              content:   [{text: "messenger"}]
            }
          }, {
            text: "\n"
          }, {
            element: {
              start_tag: {name: "p"},
              end_tag:   {name: "p"},
              content:   [{text: "bag"}]
            }
          }, {
            text: "\n"
          }, {
            element: {
              start_tag: {name: "p"},
              end_tag:   {name: "p"},
              content:   [{text: "skateboard"}]
            }
          }
        ]
      end
    end

    context "with nested elements" do
      let(:html) { "<p>messenger <strong>bag</strong> skateboard</p>" }

      it do
        should == [
          {
            element: {
              start_tag: {name: "p"},
              end_tag:   {name: "p"},
              content:   [
                {text: "messenger "},
                {
                  element: {
                    start_tag: {name: "strong"},
                    content:   [{text: "bag"}],
                    end_tag:   {name: "strong"}
                  }
                }, {
                  text: " skateboard"
                }
              ]
            }
          }
        ]
      end
    end
  end
end

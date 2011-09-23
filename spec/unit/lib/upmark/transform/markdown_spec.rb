require "spec_helper"

describe Upmark::Transform::Markdown do
  let(:transform) { Upmark::Transform::Markdown.new }

  context "#apply" do
    subject { transform.apply(ast) }

    context "<p>" do
      context "single element" do
        let(:ast) do
          [
            {
              element: {
                tag:     {name: "p", attributes: []},
                content: [{text: "messenger bag skateboard"}]
              }
            }
          ]
        end

        it { should == ["messenger bag skateboard\n\n"] }
      end

      context "multiple elements" do
        let(:ast) do
          [
            {
              element: {
                tag:     {name: "p", attributes: []},
                content: [{text: "messenger"}]
              }
            }, {
              element: {
                tag:     {name: "p", attributes: []},
                content: [{text: "bag"}]
              }
            }, {
              element: {
                tag:     {name: "p", attributes: []},
                content: [{text: "skateboard"}]
              }
            }
          ]
        end

        it { should == ["messenger\n\n", "bag\n\n", "skateboard\n\n"] }
      end
    end

    context "<a>" do
      context "single element" do
        let(:ast) do
          [
            {
              element: {
                tag: {
                  name: "a",
                  attributes: [
                    {name: "href",  value: "http://helvetica.com/"},
                    {name: "title", value: "art party organic"}
                  ]
                },
                content: [{text: "messenger bag skateboard"}]
              }
            }
          ]
        end

        it { should == [%q{[messenger bag skateboard](http://helvetica.com/ "art party organic")}] }
      end
    end

    context "<img>" do
      context "empty element" do
        let(:ast) do
          [
            {
              element: {
                tag: {
                  name: "img",
                  attributes: [
                    {name: "src",   value: "http://helvetica.com/image.gif"},
                    {name: "title", value: "art party organic"},
                    {name: "alt",   value: "messenger bag skateboard"}
                  ]
                },
                content: []
              }
            }
          ]
        end

        it { should == [%q{![messenger bag skateboard](http://helvetica.com/image.gif "art party organic")}] }
      end
    end
  end
end

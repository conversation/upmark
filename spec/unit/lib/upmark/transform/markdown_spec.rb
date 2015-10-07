RSpec.describe Upmark::Transform::Markdown do
  let(:transformed_ast) { Upmark::Transform::Markdown.new.apply(ast) }

  context "#apply" do
    context "<p>" do
      context "single tag" do
        let(:ast) do
          [
            {
              element: {
                name: "p",
                attributes: [],
                children: [{text: "messenger bag skateboard"}],
                ignore: false
              }
            }
          ]
        end

        it 'transforms to markdown' do
          expect(
            transformed_ast
          ).to eq(["messenger bag skateboard\n\n"])
        end
      end

      context "multiple tags" do
        let(:ast) do
          [
            {
              element: {
                name: "p",
                attributes: [],
                children: [{text: "messenger"}],
                ignore: false
              }
            }, {
              element: {
                name: "p",
                attributes: [],
                children: [{text: "bag"}],
                ignore: false
              }
            }, {
              element: {
                name: "p",
                attributes: [],
                children: [{text: "skateboard"}],
                ignore: false
              }
            }
          ]
        end

        it 'transforms to markdown' do
          expect(
            transformed_ast
          ).to eq(["messenger\n\n", "bag\n\n", "skateboard\n\n"])
        end
      end
    end

    context "<a>" do
      context "single tag" do
        let(:ast) do
          [
            {
              element: {
                name: "a",
                attributes: [
                  {name: "href",  value: "http://helvetica.com/"},
                  {name: "title", value: "art party organic"}
                ],
                children: [{text: "messenger bag skateboard"}],
                ignore: false
              }
            }
          ]
        end

        it 'transforms to markdown' do
          expect(
            transformed_ast
          ).to eq([%q{[messenger bag skateboard](http://helvetica.com/ "art party organic")}])
        end
      end
    end

    context "<img>" do
      context "empty tag" do
        let(:ast) do
          [
            {
              element: {
                name: "img",
                attributes: [
                  {name: "src",   value: "http://helvetica.com/image.gif"},
                  {name: "title", value: "art party organic"},
                  {name: "alt",   value: "messenger bag skateboard"}
                ],
                children: [],
                ignore: false
              }
            }
          ]
        end

        it 'transforms to markdown' do
          expect(
            transformed_ast
          ).to eq([%q{![messenger bag skateboard](http://helvetica.com/image.gif "art party organic")}])
        end
      end
    end
  end
end

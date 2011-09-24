module Upmark
  module TransformHelpers
    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def element(*names, &block)
        names.each do |name|
          name = name.to_s.downcase
          rule(
            {
              element: {
                name:       (name != "*" ? name : simple(:name)),
                attributes: subtree(:attributes),
                children:   subtree(:children),
                ignore:     false
              }
            }
          ) do |element|
            element[:name] ||= name
            block.call(element)
          end
        end
      end

      def map_attributes_subtree(ast)
        ast.inject({}) do |hash, attribute|
          hash[attribute[:name].to_sym] = attribute[:value]
          hash
        end
      end
    end
  end
end

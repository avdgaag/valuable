module Valuable
  ##
  # Deep freezing functionality for Ruby objects
  #
  # Freeze Ruby objects like a regular +#freeze+ would do, but also freeze any
  # included values. This comes with support for commonly used Ruby classes,
  # such as +Hash+, +Array+ and +Range+.
  #
  # To make custom objects work with +DeepFreeze+, define a +#deep_freeze+
  # method.
  module DeepFreeze
    module_function

    # Like Ruby's +#freeze+ but recurses into contained values.
    def deep_freeze(obj)
      if obj.respond_to?(:deep_freeze)
        obj.deep_freeze
      elsif obj.kind_of?(Hash)
        obj.reduce({}) do |acc, (key, value)|
          acc.merge deep_freeze(key) => deep_freeze(value)
        end.freeze
      elsif obj.kind_of?(Array)
        obj.reduce([]) do |acc, value|
          acc << deep_freeze(value)
        end.freeze
      elsif obj.kind_of?(Range)
        deep_freeze(obj.begin)..deep_freeze(obj.end).freeze
      elsif obj.kind_of?(Symbol)
        obj
      else
        obj.dup.freeze
      end
    end
  end
end

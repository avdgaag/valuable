module Valuable
  module DeepFreeze
    module_function

    def deep_freeze(obj)
      if obj.kind_of?(Hash)
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

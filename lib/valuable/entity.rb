require_relative './deep_freeze'

module Valuable
  module Entity
    def self.included(cls)
      cls.extend ClassMethods
    end

    module ClassMethods
      def attributes(*names)
        return @attributes unless names.any?
        @attributes = names
        mod = Module.new do
          names.each do |name|
            define_method(name) do
              @attributes.fetch(name)
            end
          end
        end
        include mod
      end
    end

    attr_reader :hash

    attr_reader :attributes
    protected :attributes

    def initialize(**kwargs)
      assert_required_attributes(kwargs)
      assert_no_extra_attributes(kwargs)
      @attributes = Valuable::DeepFreeze.deep_freeze(kwargs)
      @hash = self.class.hash ^ @attributes.hash
      freeze
    end

    def ==(other)
      self.class == other.class &&
        attributes == other.attributes
    end
    alias_method :eql?, :==

    def to_h
      @attributes
    end

    def inspect
      "#<#{self.class} #{attributes.map { |k, v| "#{k}: #{v.inspect}" }.join(' ')}>"
    end

    private

    def assert_required_attributes(attrs)
      return unless self.class.attributes
      missing_attributes = self.class.attributes - attrs.keys
      if missing_attributes.any?
        raise ArgumentError, 'Missing attributes: ' + missing_attributes.join(', ')
      end
    end

    def assert_no_extra_attributes(attrs)
      return unless self.class.attributes
      extra_attributes = attrs.keys - self.class.attributes
      if extra_attributes.any?
        raise ArgumentError, 'Unexpected attributes: ' + extra_attributes.join(', ')
      end
    end
  end
end

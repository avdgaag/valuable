require_relative './deep_freeze'

module Valuable
  ##
  # Include +Entity+ to make a class an immutable value object.
  module Entity
    def self.included(cls) # :nodoc:
      cls.extend ClassMethods
    end

    module ClassMethods
      ##
      # Define an explicit list of attribute names.
      #
      # When you explicitly define attributes, you ensure objects can only be
      # created with those attributes. Missing or unexpected attributes will
      # trigger an +ArgumentError+.
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

    attr_reader :hash # :nodoc:

    attr_reader :attributes # :nodoc:
    protected :attributes

    ##
    # Initialize a new entity
    #
    # Provide the entity's attributes as key/value pairs in +kwargs+. Any
    # attributes you provide will be duplicated and frozen, so you need not
    # worry about later modifications to any values passed in.
    def initialize(**kwargs)
      assert_required_attributes(kwargs)
      assert_no_extra_attributes(kwargs)
      @attributes = Valuable::DeepFreeze.deep_freeze(kwargs)
      @hash = self.class.hash ^ @attributes.hash
      freeze
    end

    # Comparse two objects
    #
    # Two entities are considered equal if they are instances of the same class
    # and their internal attributes are equal.
    def ==(other)
      self.class == other.class &&
        attributes == other.attributes
    end
    alias_method :eql?, :==

    # Get a Hash representation of this entity.
    def to_h
      @attributes
    end

    def inspect # :nodoc:
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

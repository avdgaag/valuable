require 'test_helper'

class Valuables::EntityTest < Minitest::Test
  def setup
    @entity_class = Class.new do
      include Valuables::Entity
    end
  end

  def test_instances_are_frozen
    assert @entity_class.new.frozen?
  end

  def test_defines_a_hash_attribute
    refute_nil @entity_class.new.hash
  end

  def test_considers_two_empty_entities_equal
    assert_equal @entity_class.new, @entity_class.new
  end

  def test_considers_two_entities_with_same_values_equal
    assert_equal @entity_class.new(attr: 'value'), @entity_class.new(attr: 'value')
  end

  def test_has_the_same_hash_for_same_attributes
    assert_equal @entity_class.new(attr: 'value').hash, @entity_class.new(attr: 'value').hash
  end

  def test_considers_two_entities_with_different_values_unequal
    refute_equal @entity_class.new(attr: 'value'), @entity_class.new(attr: 'other value')
  end

  def test_has_different_hash_for_different_attributes
    refute_equal @entity_class.new(attr: 'value').hash, @entity_class.new(attr: 'other value').hash
  end

  def test_it_converts_to_a_hash
    assert_equal({ attr: 'value' }, @entity_class.new(attr: 'value').to_h)
  end

  def test_its_hash_representation_is_not_frozen
    refute @entity_class.new(attr: 'value').to_h.frozen?, 'Attributes should not be frozen'
  end

  def test_prints_attributes_when_inspecting
    assert_equal "#<#{@entity_class} foo: \"bar\">", @entity_class.new(foo: 'bar').inspect
  end

  def test_explicit_attributes_are_required
    @entity_class.attributes :title, :author
    assert_raises(ArgumentError, 'Missing attributes: author') do
      @entity_class.new(title: '1984')
    end
  end

  def test_extra_attributes_are_not_allowed
    @entity_class.attributes :title, :author
    assert_raises(ArgumentError, 'Missing attributes: author') do
      @entity_class.new(year: '1948')
    end
  end

  def test_defines_readers_for_explicit_attributes
    @entity_class.attributes :title, :author
    obj = @entity_class.new(title: '1983', author: 'Orwell')
    assert_equal '1983', obj.title
    assert_equal 'Orwell', obj.author
  end

  def test_cannot_modify_attributes
    attributes = { title: '1983' }
    @entity_class.attributes :title
    obj = @entity_class.new(attributes)
    attributes[:author] = 'Orwell'
    assert_nil obj.send(:attributes)[:author]
  end

  def test_cannot_modify_attribute_values
    attributes = { author: 'Orwell', tags: ['tag1', 'tag2'] }
    @entity_class.attributes :author, :tags
    obj = @entity_class.new(attributes)
    attributes[:author].upcase!
    attributes[:tags] << 'tag3'
    attributes[:tags][0].upcase!
    assert_equal 'Orwell', obj.author
    assert_equal ['tag1', 'tag2'], obj.tags
  end
end

require 'test_helper'

class DeepFreezeTest < Minitest::Test
  def test_it_freezes_strings
    assert Valuables::DeepFreeze.deep_freeze('string').frozen?
  end

  def test_it_freezes_hashes
    attr = { title: 'string' }
    frozen_attr = Valuables::DeepFreeze.deep_freeze(attr)
    assert frozen_attr.frozen?
  end

  def test_it_freezes_hash_values
    attr = { title: 'string' }
    frozen_attr = Valuables::DeepFreeze.deep_freeze(attr)
    assert frozen_attr[:title].frozen?
  end

  def test_it_freezes_hash_values
    attr = { 'title' => 'string' }
    frozen_attr = Valuables::DeepFreeze.deep_freeze(attr)
    assert frozen_attr.invert['string'].frozen?
  end

  def test_it_freezes_arrays
    assert Valuables::DeepFreeze.deep_freeze(['a', 'b']).frozen?
  end

  def test_it_freezes_arrays_values
    arr = ['a', 'b']
    frozen_arr = Valuables::DeepFreeze.deep_freeze(arr)
    assert frozen_arr[0].frozen?
    assert frozen_arr[1].frozen?
  end

  def test_it_reuses_symbols
    assert_equal :symbol, Valuables::DeepFreeze.deep_freeze(:symbol)
  end

  def test_it_freezes_ranges
    assert Valuables::DeepFreeze.deep_freeze('a'..'z').frozen?
  end

  def test_it_freezes_ranges
    a = 'a'
    z = 'z'
    frozen_range = Valuables::DeepFreeze.deep_freeze(a..z)
    assert frozen_range.begin.frozen?
    assert frozen_range.end.frozen?
  end
end

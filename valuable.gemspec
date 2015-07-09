# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'valuable/version'

Gem::Specification.new do |spec|
  spec.name          = 'valuable'
  spec.version       = Valuable::VERSION
  spec.authors       = ['Arjan van der Gaag']
  spec.email         = ['arjan@arjanvandergaag.nl']

  spec.summary       = %q{Immutable value objects in Ruby}
  spec.description   = <<-EOS
Sometimes, your objects are only data and no behaviour. These are value
objects, and they are defined by their _contents_. These objects are immutable,
so it is safe to let them propagate throughout the system.

Being immutable, value objects cannot be modified; their contents are set once
on initialisation. Also, being identified by their contents, two entities with
the same contents are considered equal.
EOS

  spec.homepage      = 'http://avdgaag.github.io/valuable'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest'
end

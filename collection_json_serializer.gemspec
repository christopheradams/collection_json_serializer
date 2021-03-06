# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'collection_json_serializer/version'

Gem::Specification.new do |spec|
  spec.name          = "collection_json_serializer"
  spec.version       = CollectionJson::Serializer::VERSION
  spec.authors       = ["Carles Jove i Buxeda"]
  spec.email         = ["hola@carlus.cat"]
  spec.summary       = %q{Serialize objects as Collection+JSON.}
  spec.description   = %q{CollectionJson::Serializer makes it easy to serialize objects into the Collection+JSON hypermedia type.}
  spec.homepage      = "https://github.com/carlesjove/collection_json_serializer"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 4.1"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.4"
end

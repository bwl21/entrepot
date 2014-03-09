# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'entrepot/version'

Gem::Specification.new do |spec|
  spec.name          = "entrepot"
  spec.version       = Entrepot::VERSION
  spec.authors       = ["Bernhard Weichel"]
  spec.email         = ["github.com@nospam.weichel21.de"]
  spec.description   = %q{a helper class do do a chached processing}
  spec.summary       = %q{Ruby is excellent for transforming and filtering data.

Rubyists often use these capabilities to manipulate large amounts of data in a multi-step pipeline way.
Entrepot memorizes the results along the way to speed up repetitive processing. If only parts of the original data change, not all of it has to be recomputed. 

Immerdiate results are stored on disk, to enable defered processing and reuse of previous results.
}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  spec.add_runtime_dependency 'digest'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"

end

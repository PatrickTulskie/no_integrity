lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'no_integrity/version'

Gem::Specification.new do |gem|
  gem.name          = %q{no_integrity}
  gem.version       = NoIntegrity::VERSION

  gem.authors       = ["Patrick Tulskie"]
  gem.email         = ["patricktulskie@gmail.com"]
  gem.summary       = %q{Key/value store inside of your model.}
  gem.description   = %q{Add attributes without any sort of integrity to your ActiveRecord or other types of objects.}
  gem.homepage      = "http://github.com/PatrickTulskie/no_integrity"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency(%q<rspec>, ["~> 3.4.0"])
end
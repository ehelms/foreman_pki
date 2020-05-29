
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "foreman_pki/version"

Gem::Specification.new do |spec|
  spec.name          = "foreman_pki"
  spec.version       = ForemanPki::VERSION
  spec.authors       = ["Eric D. Helms"]
  spec.email         = ["ericdhelms@gmail.com"]

  spec.summary       = %q{Create certificates for Foreman}
  spec.description   = %q{Create certificates for Foreman}
  spec.homepage      = "https://theforeman.org"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "clamp"

  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end

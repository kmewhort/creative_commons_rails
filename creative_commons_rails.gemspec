# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'creative_commons_rails/version'

Gem::Specification.new do |spec|
  spec.name          = "creative_commons_rails"
  spec.version       = CreativeCommonsRails::VERSION
  spec.authors       = ["Kent Mewhort"]
  spec.email         = ["kent@openissues.ca"]
  spec.description   = %q{Render internationalized Creative Commons license notices in your views}
  spec.summary       = %q{Easy rendering of Creative Commons license notices}
  spec.homepage      = "http://github.com/kmewhort/creative_commons_rails"
  spec.license       = "BSD"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "mechanize"
  spec.add_runtime_dependency "rails"
  spec.add_runtime_dependency "i18n"
end

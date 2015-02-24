# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'auto_select2/version'

Gem::Specification.new do |spec|
  spec.name          = "auto_select2"
  spec.version       = AutoSelect2::VERSION
  spec.authors       = ["Dmitriy Lisichkin", "Ivan Zabrovskiy"]
  spec.email         = ["dima@sb42.ru", "loriowar@gmail.com"]
  spec.summary       = %q{Base methods for wrapping a Select2 and easy initialize it.}
  spec.description   = <<-DESC
    Gem provide scripts and helpers for initialize different select2 elements:
    static, ajax and multi-ajax. Moreover this gem is foundation for other gems.
    For example for AutoSelect2Tab.
  DESC
  spec.homepage      = "https://github.com/Loriowar/auto_select2"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "railties", ">= 3.1"
  spec.add_dependency 'select2-rails'
  spec.add_dependency 'coffee-rails'

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rails", "~> 3.2.12"
end

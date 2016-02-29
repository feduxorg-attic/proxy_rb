# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'proxy_rb/version'

Gem::Specification.new do |spec|
  spec.name          = 'proxy_rb'
  spec.version       = ProxyRb::VERSION
  spec.authors       = ['Max Meyer']
  spec.email         = ['dev@fedux.org']

  spec.summary       = 'This gem makes testing your proxy easy.'
  spec.homepage      = 'https://github.com/fedux-org/proxy_rb'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_runtime_dependency 'capybara'
  spec.add_runtime_dependency 'poltergeist'

  spec.add_runtime_dependency 'addressable'
  spec.add_runtime_dependency 'contracts'
  spec.add_runtime_dependency 'excon'
  #  spec.add_runtime_dependency 'phantomjs'

  spec.required_ruby_version = '~> 2.0'
end

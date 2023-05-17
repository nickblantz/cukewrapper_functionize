# frozen_string_literal: true

require_relative 'lib/cukewrapper_functionize/version'

Gem::Specification.new do |spec|
  spec.name = 'cukewrapper_functionize'
  spec.version = CukewrapperFunctionize::VERSION
  spec.authors = ['Nick Blantz']
  spec.email = ['nicholasblantz@gmail.com']
  spec.summary = 'Provides a wrapper for online testing tools with Cucumber'
  spec.metadata = { 'rubygems_mfa_required' => 'true' }
  spec.description = File.read('README.md')
  spec.homepage = 'https://github.com/nickblantz'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.0')
  spec.files = Dir[
    'lib/**/*',
    'README.md',
    'LICENSE'
  ]
  spec.add_dependency 'cukewrapper', '0.3.0.unified.config'
  spec.add_runtime_dependency 'httparty', '~> 0.0'
  spec.add_runtime_dependency 'json', '~> 2.0'
end

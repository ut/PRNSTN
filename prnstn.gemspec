# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prnstn/version'

Gem::Specification.new do |spec|
  spec.name          = 'PRNSTN'
  spec.version       = Prnstn::VERSION
  spec.authors       = ['Ulf Treger']
  spec.email         = ['ulf.treger@googlemail.com']

  spec.summary = 'Script to handle a printer and feed it w/social media content'
  spec.homepage = 'https://ut.github.io/prnstn'
  spec.license = 'GNU GPL v3'

  # Prevent pushing this gem to RubyGems.org.
  # To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata['allowed_push_host'] = 'TODO: Set to 'http://mygemserver.com''
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split('\x0').reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.files = ['lib/prnstn.rb']

  spec.bindir = 'bin'
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'activerecord', '~>5'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'colorize'
  spec.add_development_dependency 'cupsffi', '~> 0.1'
  spec.add_development_dependency 'rake', '~> 12'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'wiringpi', '~> 2.3'
end

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
  # spec.description   = 'TODO: Write a longer description or delete this line.'
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
  spec.executables  = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'cupsffi', '~> 0.1'
  spec.add_development_dependency 'rubocop', '~> 0.47.1'
  spec.add_development_dependency 'webmock', '~> 2.3'
  spec.add_development_dependency 'twitter'
  spec.add_development_dependency 'activerecord', '~>4.2'
  spec.add_development_dependency 'sqlite3'
end

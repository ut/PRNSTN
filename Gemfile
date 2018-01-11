source 'https://rubygems.org'

# Specify your gem's dependencies in prnstn.gemspec
gemspec

group :production, :development do
  gem 'twitter', '~> 6.2', :git => 'https://github.com/ut/twitter.git'
end

group :test do
  gem 'rspec'
  gem 'vcr'
  gem 'webmock'
end
require_relative "lib/hotwire_spark/version"

Gem::Specification.new do |spec|
  spec.name        = "hotwire_spark"
  spec.version     = HotwireSpark::VERSION
  spec.authors     = [ "Jorge Manrubia" ]
  spec.email       = [ "jorge@37signals.com" ]
  spec.homepage    = "https://github.com/basecamp/hotwire_spark"
  spec.summary     = "PENDING: Summary of HotwireSpark."
  spec.description = "PENDING: Description of HotwireSpark."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "PENDING: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/basecamp/hotwire_spark"
  spec.metadata["changelog_uri"] = "https://github.com/basecamp/hotwire_spark"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.0.0"
  spec.add_dependency "zeitwerk"
  spec.add_dependency "listen"
  spec.add_dependency "turbo-rails"
  spec.add_dependency "faye-websocket"

  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-rails-omakase"
end

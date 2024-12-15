require_relative "lib/hotwire_spark/version"

Gem::Specification.new do |spec|
  spec.name        = "hotwire_spark"
  spec.version     = HotwireSpark::VERSION
  spec.authors     = [ "Jorge Manrubia" ]
  spec.email       = [ "jorge@37signals.com" ]
  spec.homepage    = "https://github.com/basecamp/hotwire_spark"
  spec.summary     = "🤫"
  spec.description = "🤫"
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/basecamp/hotwire_spark"
  spec.metadata["changelog_uri"] = "https://github.com/basecamp/hotwire_spark"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.0.0"
end

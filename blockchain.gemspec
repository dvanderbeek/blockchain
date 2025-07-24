require_relative "lib/blockchain/version"

Gem::Specification.new do |spec|
  spec.name        = "blockchain"
  spec.version     = Blockchain::VERSION
  spec.authors     = [ "David Van Der Beek" ]
  spec.email       = [ "earlynovrock@gmail.com" ]
  spec.homepage    = "https://github.com/figment-network/blockchain"
  spec.summary     = "Transaction Tracking for Blockchain Protocols."
  spec.description = "Transaction Tracking for Blockchain Protocols."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_development_dependency "debug"
  spec.add_dependency "rails", ">= 7"
  spec.add_dependency "httparty"
end

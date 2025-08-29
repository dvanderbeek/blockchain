require "blockchain/version"
require "blockchain/engine"
require "debug"
require "httparty"

module Blockchain
  class Configuration
    attr_accessor :transaction_confirmed
  end

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.transaction_confirmed(tx) = configuration.transaction_confirmed.call(tx)
end

require "blockchain/version"
require "blockchain/engine"
require "debug"
require "httparty"

module Blockchain
  def self.configure(&block)
    @configuration ||= Configuration.new
    block.call(@configuration) if block
    @configuration
  end

  def self.tx_processors
    @configuration.tx_processors
  end

  def self.transaction_completed(transaction)
    tx_processor = tx_processors[transaction.protocol][transaction.type]
    tx_processor&.safe_constantize&.new(transaction)&.process if tx_processor
  end

  class Configuration
    attr_accessor :tx_processors

    def initialize
      @tx_processors = {}
    end

    def register_tx_processor(protocol, operation, processor)
      @tx_processors[protocol] ||= {}
      @tx_processors[protocol][operation] = processor
    end
  end
end

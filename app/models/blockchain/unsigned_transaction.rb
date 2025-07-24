module Blockchain
  class UnsignedTransaction
    include ActiveModel::Model

    attr_accessor :transaction_payload, :signing_payload

    def self.for(protocol, action)
      "Blockchain::#{protocol.camelize}::UnsignedTransactions::#{action.camelize}Transaction".constantize
    end
  end
end

module Blockchain
  class UnsignedTransaction < ApplicationRecord
    attr_accessor :transaction_payload, :signing_payload

    def self.for(protocol, action)
      "Blockchain::#{protocol.camelize}::UnsignedTransactions::#{action.camelize}Transaction".constantize
    end

    before_create do
      self.nonce = nonce
      self.address = address
      self.fingerprint = calculate_fingerprint
    end

    def calculate_fingerprint
      data = {
        nonce:,
        address:,
        inputs:
      }

      Digest::SHA256.hexdigest data.to_json
    end
  end
end

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

    after_create do
      # TODO: Make this configurable (config.user_klass = Organization or a lambda for the full callback)
      # or use events (less common for gems)
      Current.user&.add_wallet(network, protocol, address)
    end

    # Once we track an onchain transaction, we need to do something similar and have the main app call the Delegations::UpsertStake

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

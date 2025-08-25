# t.string "protocol"
# t.string "network"
# t.string "tx_hash"
# t.string "sender_address"
# t.json "onchain_info"
# t.json "status_info"

# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false

module Blockchain
  class Transaction < ApplicationRecord
    # TODO: All onchain transaction parsers need to implement these methods
    delegate :nonce, :type, :amount_base_units, :wallet_address, to: :onchain_tx

    before_create :fetch_onchain_data

    after_create do
      TransactionTrackingJob.perform_later(id) unless completed?
    end

    after_save do
      Adapters::TransactionAdapterFactory.build(self)&.process if confirmed?
    end

    def source
      unsigned_transaction&.source || 'external'
    end

    def unsigned_transaction
      @unsigned_transaction ||= UnsignedTransaction.find_by(
        protocol:,
        network:,
        fingerprint: onchain_tx.fingerprint
      )
    end

    def completed?
      onchain_tx.status&.terminal?
    end

    def confirmed?
      onchain_tx.status == Blockchain::Status::CONFIRMED
    end

    def track
      fetch_onchain_data
      save!
    rescue NameError
      puts "Transaction Tracking not implemented for #{protocol}"
    end

    def fetch_onchain_data
      self.onchain_status = status_klass.new(network:, hash: tx_hash, tx: self).info
      self.onchain_info   = info_klass.new(network:, hash: tx_hash, tx: self).info
    end

    def onchain_tx
      @onchain_tx ||= onchain_tx_klass.new(network:, hash: tx_hash, status_info: onchain_status, info: onchain_info)
    end

    private

    def status_klass
      "Blockchain::#{protocol.camelize}::TransactionStatus".constantize
    end

    def info_klass
      "Blockchain::#{protocol.camelize}::TransactionInfo".constantize
    end

    def onchain_tx_klass
      "Blockchain::#{protocol.camelize}::Transaction".constantize
    end
  end
end

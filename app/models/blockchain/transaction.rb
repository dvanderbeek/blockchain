module Blockchain
  class Transaction < ApplicationRecord
    before_create :fetch_onchain_data
    after_create { TransactionTrackingJob.perform_later(id) unless completed? }

    def completed?
      onchain_tx.status&.terminal?
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

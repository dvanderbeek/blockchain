module Blockchain::Near
  class TransactionInfo
    include ActiveModel::Model

    attr_accessor :network, :hash, :tx

    def info
      @info ||= tx_info.merge(timestamp: timestamp)
    end

    private

    def tx_info
      @tx_info ||= Blockchain::Rpc.new('near', network).tx(
        tx_hash: hash,
        sender_account_id: tx.sender_address,
        wait_until: 'NONE'
      )
    end

    def block_info
      @block_info ||= Blockchain::Rpc.new('near', network).block({ block_id: blockhash })
    end

    def blockhash
      tx_info.dig('result', 'transaction_outcome', 'block_hash')
    end

    def timestamp
      timestamp = block_info.dig('result', 'header', 'timestamp')
      Time.at(timestamp / 1_000_000_000) if timestamp.present?
    end
  end
end

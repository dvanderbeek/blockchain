module Blockchain::Near
  class TransactionInfo
    include ActiveModel::Model

    attr_accessor :network, :hash, :tx

    def info
      @info ||= Blockchain::Rpc.new('near', network).tx(
        tx_hash: hash,
        sender_account_id: tx.sender_address,
        wait_until: 'NONE'
      )
    end
  end
end

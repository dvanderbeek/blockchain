module Solana
  class TransactionInfo
    include ActiveModel::Model

    attr_accessor :network, :hash, :tx

    def info
      @info ||= Blockchain::Rpc.new('solana', network).get_transaction([
        hash,
        {
          maxSupportedTransactionVersion: 0,
          encoding: 'jsonParsed'
        }
      ])
    end
  end
end

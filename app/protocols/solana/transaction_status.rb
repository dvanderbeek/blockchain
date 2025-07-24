module Solana
  class TransactionStatus
    include ActiveModel::Model

    attr_accessor :network, :hash, :tx

    def info
      @info ||= Blockchain::Rpc.new('solana', network).get_signature_statuses([
        [hash],
        {
          searchTransactionHistory: true,
          encoding: 'jsonParsed'
        }
      ])
    end
  end
end

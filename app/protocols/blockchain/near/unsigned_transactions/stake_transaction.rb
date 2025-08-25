module Blockchain::Near
  module UnsignedTransactions
    class StakeTransaction < BaseTransaction
      store_accessor :inputs, :wallet_address, :wallet_pubkey, :validator_address, :amount

      validates :amount, numericality: { less_than_or_equal_to: 10 }

      # TODO: This is basically what we have already with the Transactions pack
      # We could also expose slate-networks endpoints directly and eliminate a whole layer in Core
      def response
        @response ||= HTTParty.post("#{slate_networks_url}/delegate_transaction", body: {
          validatorAddress: validator_address,
          delegatorAddress: wallet_address,
          delegatorPubKey: wallet_pubkey,
          amount: amount.to_s
        }.to_json, headers:)
      end

      def address
        wallet_address
      end
    end
  end
end

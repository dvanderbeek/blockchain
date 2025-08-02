module Blockchain::Solana
  module UnsignedTransactions
    class StakeTransaction < BaseTransaction
      store_accessor :inputs, :wallet_address, :validator_address, :amount

      validates :amount, numericality: { less_than_or_equal_to: 10 }

      # TODO: This is basically what we have already with the Transactions pack
      # We could also expose slate-networks endpoints directly and eliminate a whole layer in Core
      def response
        @response ||= HTTParty.post("#{slate_networks_url}/create_stake_account_transaction", body: {
          validatorAddress: validator_address,
          fundingAccountPubKey: wallet_address,
          stakeAuthorityPubKey: wallet_address,
          withdrawAuthorityPubKey: wallet_address,
          amount:
        }.to_json, headers:)
      end

      def address
        wallet_address
      end
    end
  end
end

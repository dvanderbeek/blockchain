module Blockchain::Solana
  module UnsignedTransactions
    class StakeTransaction < BaseTransaction
      store_accessor :inputs, :wallet_address, :validator_address, :amount

      validates :amount, numericality: { less_than_or_equal_to: 10 }

      def amount=(value)
        super(coerce_amount(value))
      end

      def inputs=(hash)
        return super(hash) unless hash

        hash = hash.stringify_keys.dup
        self.class.stored_attributes[:inputs]&.each do |attr|
          value = hash[attr.to_s]
          # Apply coercion for custom setters without calling them (to avoid loop)
          hash[attr.to_s] = coerce_value_for_attribute(attr, value)
        end
        super(hash)
      end

      private

      def coerce_amount(value)
        value&.to_f
      end

      def coerce_value_for_attribute(attr, value)
        respond_to?("coerce_#{attr}", true) ? send("coerce_#{attr}", value) : value
      end

      # TODO: This is basically what we have already with the Transactions pack
      # We could also expose slate-networks endpoints directly and eliminate a whole layer in Core
      def response
        @response ||= HTTParty.post("#{slate_networks_url}/build-stake", body: {
          voteAccount: validator_address,
          feePayer: wallet_address,
          amountLamports: amount * 10**9
        }.to_json, headers:)
      end

      def address
        wallet_address
      end
    end
  end
end

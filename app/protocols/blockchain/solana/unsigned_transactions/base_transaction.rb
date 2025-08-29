module Blockchain::Solana
  module UnsignedTransactions
    class BaseTransaction < ::Blockchain::UnsignedTransaction
      def transaction_payload
        {
          hex: response["unsignedTransaction"]["hex"],
          base64: response["unsignedTransaction"]["base64"]
        }
      end

      def signing_payload
        response["signingPayload"]
      end

      def nonce
        response["recentBlockhash"]
      end

      private

      def slate_networks_url
        'http://localhost:3300/solana'
      end

      def headers
        { 'Content-Type' => 'application/json', 'x-network-name' => network }
      end
    end
  end
end

module Blockchain::Solana
  module UnsignedTransactions
    class BaseTransaction < ::Blockchain::UnsignedTransaction
      def transaction_payload
        {
          hex: response["transactionPayloadHex"],
          base64: response["transactionPayloadBase64"]
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
        'https://dvdb.loca.lt/solana'
      end

      def headers
        { 'Content-Type' => 'application/json', 'x-network-name' => network }
      end
    end
  end
end

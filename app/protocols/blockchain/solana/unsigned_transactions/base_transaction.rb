module Blockchain::Solana
  module UnsignedTransactions
    class BaseTransaction < ::Blockchain::UnsignedTransaction
      attr_accessor :network

      def transaction_payload
        {
          hex: response["transactionPayloadHex"],
          base64: response["transactionPayloadBase64"]
        }
      end

      def signing_payload
        response["signingPayload"]
      end

      private

      def slate_networks_url
        'http://localhost:8081/solana'
      end

      def headers
        { 'Content-Type' => 'application/json', 'x-network-name' => network }
      end
    end
  end
end

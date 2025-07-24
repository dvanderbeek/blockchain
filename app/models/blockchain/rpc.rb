require 'net/http'
require 'json'

module Blockchain
  class Rpc
    def initialize(protocol, network)
      @protocol = protocol
      @network = network
    end

    def rpc_url
      protocol = "Blockchain::#{@protocol.camelize}".safe_constantize
      network = protocol&.networks[@network.to_sym]
      url = network&.dig(:rpc_url)

      if protocol.blank? || network.blank? || url.blank?
        raise NotImplementedError, "RPC URL not configured for #{@protocol} on #{@network}"
      end

      URI(url)
    end

    def method_missing(method_name, *args, &block)
      request(method_name.to_s.camelize(:lower), args[0])
    end

    def request(method, params = [])
      uri = rpc_url

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri)
      request['Content-Type'] = 'application/json'

      request.body = {
        jsonrpc: '2.0',
        id: 1,
        method:,
        params:
      }.to_json

      response = http.request(request)
      JSON.parse(response.body)
    end
  end
end

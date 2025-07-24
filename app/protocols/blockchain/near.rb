module Blockchain::Near
  module_function

  def networks
    {
      mainnet: {
        rpc_url: 'https://rpc.mainnet.near.org',
        explorer_url: 'https://nearblocks.io'
      },
      testnet: {
        rpc_url: 'https://rpc.testnet.near.org',
        explorer_url: 'https://testnet.nearblocks.io'
      }
    }
  end
end

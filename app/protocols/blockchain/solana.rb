module Blockchain::Solana
  module_function

  def networks
    {
      mainnet: {
        rpc_url: 'https://api.mainnet-beta.solana.com',
        explorer_url: 'https://solscan.io'
      },
      devnet: {
        rpc_url: 'https://api.devnet.solana.com',
        explorer_url: 'https://solscan.io'
      }
    }
  end
end

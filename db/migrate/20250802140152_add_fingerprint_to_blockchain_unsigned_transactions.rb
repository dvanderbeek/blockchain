class AddFingerprintToBlockchainUnsignedTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :blockchain_unsigned_transactions, :fingerprint, :string
  end
end

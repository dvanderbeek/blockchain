class AddFingerprintToBlockchainTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :blockchain_transactions, :fingerprint, :string
    add_index :blockchain_transactions, :fingerprint
  end
end

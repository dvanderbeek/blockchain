class AddInputsToUnsignedTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :blockchain_unsigned_transactions, :inputs, :json
  end
end

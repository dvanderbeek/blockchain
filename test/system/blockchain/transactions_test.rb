require "application_system_test_case"

module Blockchain
  class TransactionsTest < ApplicationSystemTestCase
    setup do
      @transaction = blockchain_transactions(:one)
    end

    test "visiting the index" do
      visit transactions_url
      assert_selector "h1", text: "Transactions"
    end

    test "should create transaction" do
      visit transactions_url
      click_on "New transaction"

      fill_in "Network", with: @transaction.network
      fill_in "Protocol", with: @transaction.protocol
      fill_in "Status", with: @transaction.status
      fill_in "Tx hash", with: @transaction.tx_hash
      click_on "Create Transaction"

      assert_text "Transaction was successfully created"
      click_on "Back"
    end

    test "should update Transaction" do
      visit transaction_url(@transaction)
      click_on "Edit this transaction", match: :first

      fill_in "Network", with: @transaction.network
      fill_in "Protocol", with: @transaction.protocol
      fill_in "Status", with: @transaction.status
      fill_in "Tx hash", with: @transaction.tx_hash
      click_on "Update Transaction"

      assert_text "Transaction was successfully updated"
      click_on "Back"
    end

    test "should destroy Transaction" do
      visit transaction_url(@transaction)
      click_on "Destroy this transaction", match: :first

      assert_text "Transaction was successfully destroyed"
    end
  end
end

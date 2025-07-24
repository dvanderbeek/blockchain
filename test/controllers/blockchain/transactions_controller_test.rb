require "test_helper"

module Blockchain
  class TransactionsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @transaction = blockchain_transactions(:one)
    end

    test "should get index" do
      get transactions_url
      assert_response :success
    end

    test "should get new" do
      get new_transaction_url
      assert_response :success
    end

    test "should create transaction" do
      assert_difference("Transaction.count") do
        post transactions_url, params: { transaction: { network: @transaction.network, protocol: @transaction.protocol, status: @transaction.status, tx_hash: @transaction.tx_hash } }
      end

      assert_redirected_to transaction_url(Transaction.last)
    end

    test "should show transaction" do
      get transaction_url(@transaction)
      assert_response :success
    end

    test "should get edit" do
      get edit_transaction_url(@transaction)
      assert_response :success
    end

    test "should update transaction" do
      patch transaction_url(@transaction), params: { transaction: { network: @transaction.network, protocol: @transaction.protocol, status: @transaction.status, tx_hash: @transaction.tx_hash } }
      assert_redirected_to transaction_url(@transaction)
    end

    test "should destroy transaction" do
      assert_difference("Transaction.count", -1) do
        delete transaction_url(@transaction)
      end

      assert_redirected_to transactions_url
    end
  end
end

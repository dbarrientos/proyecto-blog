class AddCamposToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :transaction_type, :string
    add_column :payments, :transaction_date, :string
    add_column :payments, :number_shares, :string
    add_column :payments, :tbk_amount, :string
  end
end

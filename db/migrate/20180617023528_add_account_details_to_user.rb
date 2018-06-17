class AddAccountDetailsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :saldo, :integer, default: 0
    add_column :users, :deuda, :integer, default: 0
  end
end

class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.float :deuda, default: 0
      t.float :saldo, default: 0
      t.timestamps
    end
  end
end

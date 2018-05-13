class AddTarjetaToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :tarjeta, :string
  end
end

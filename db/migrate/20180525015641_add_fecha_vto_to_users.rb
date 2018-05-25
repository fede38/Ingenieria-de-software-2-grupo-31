class AddFechaVtoToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :fecha_vencimiento, :date
  end
end

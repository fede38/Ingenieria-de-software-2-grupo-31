class AddActivoToViajes < ActiveRecord::Migration[5.0]
  def change
    add_column :trips, :activo, :boolean
  end
end

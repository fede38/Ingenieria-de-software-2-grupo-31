class CreateVehicles < ActiveRecord::Migration[5.0]
  def change
    create_table :vehicles do |t|
      t.string :patente
      t.integer :modelo
      t.string :marca
      t.integer :cantidad_asientos
      t.string :color
      t.string :tipo

      t.timestamps
    end
  end
end

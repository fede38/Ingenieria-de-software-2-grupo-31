class AddAttributesToTrips < ActiveRecord::Migration[5.0]
  def change
    add_column :trips, :fecha_inicio, :date
    add_column :trips, :hora_inicio, :time
    add_column :trips, :costo, :float
    add_column :trips, :destino, :string
  end
end

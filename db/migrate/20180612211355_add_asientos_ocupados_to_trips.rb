class AddAsientosOcupadosToTrips < ActiveRecord::Migration[5.0]
  def change
    add_column :trips, :cantidad_asientos_ocupados, :integer, default: 0
  end
end

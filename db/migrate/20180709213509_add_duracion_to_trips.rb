class AddDuracionToTrips < ActiveRecord::Migration[5.0]
  def change
  	  add_column :trips, :duracion, :float
  end
end

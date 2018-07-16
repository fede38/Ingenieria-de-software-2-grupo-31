class AddDuracionToTrips < ActiveRecord::Migration[5.0]
  def change
  	  add_column :trips, :duracion, :integer
  end
end

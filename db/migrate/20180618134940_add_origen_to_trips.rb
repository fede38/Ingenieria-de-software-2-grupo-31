class AddOrigenToTrips < ActiveRecord::Migration[5.0]
  def change
  	add_column :trips, :origen, :string
  end
end

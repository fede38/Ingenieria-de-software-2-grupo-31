class AddPagadoToTrip < ActiveRecord::Migration[5.0]
  def change
  	add_column :trips, :pagado, :boolean, default: false
  end
end

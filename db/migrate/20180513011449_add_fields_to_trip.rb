class AddFieldsToTrip < ActiveRecord::Migration[5.0]
  def change
    add_column :trips, :descripcion, :text
  end
end

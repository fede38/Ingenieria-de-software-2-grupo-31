class CambiarDefaultCantidadAsientos < ActiveRecord::Migration[5.0]
  def change
    change_column :trips, :cantidad_asientos_ocupados, :integer, default: 1
  end
end

class ActivoDefalutTrue < ActiveRecord::Migration[5.0]
  def change
  	change_column :trips, :activo, :boolean, default: true
  end
end

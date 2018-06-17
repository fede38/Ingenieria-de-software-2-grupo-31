class AddAtributesToScore < ActiveRecord::Migration[5.0]
  def change
  	add_column :scores, :tipo_calificacion, :string
  	add_column :scores, :realizada, :boolean
  end
end

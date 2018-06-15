class AddCalificacionesAUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :calificacionPiloto, :integer, default: 0
    add_column :users, :calificacionCopiloto, :integer, default: 0
  end
end

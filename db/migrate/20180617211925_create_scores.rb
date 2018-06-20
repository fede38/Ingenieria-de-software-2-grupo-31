class CreateScores < ActiveRecord::Migration[5.0]
  def change
    create_table :scores do |t|
      t.integer :calificacion
      t.text :descripcion
      t.date :fecha
      t.time :hora

      t.timestamps
    end
  end
end

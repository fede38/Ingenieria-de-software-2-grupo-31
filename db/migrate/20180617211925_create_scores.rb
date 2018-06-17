class CreateScores < ActiveRecord::Migration[5.0]
  def change
    create_table :scores do |t|
      t.integer :calificacion
      t.text :descripcion
      t.datetime :fechayhora

      t.timestamps
    end
  end
end

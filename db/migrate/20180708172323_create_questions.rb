class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.text :pregunta
      t.timestamps
    end
  end
end

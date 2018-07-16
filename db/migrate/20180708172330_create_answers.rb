class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.text :respuesta
      t.belongs_to :question, index:true
      t.timestamps
    end
  end
end

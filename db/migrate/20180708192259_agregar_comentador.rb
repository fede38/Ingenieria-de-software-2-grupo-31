class AgregarComentador < ActiveRecord::Migration[5.0]
  def change
    add_reference :questions, :user, index: true
  end
end

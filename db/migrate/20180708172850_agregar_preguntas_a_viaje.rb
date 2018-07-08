class AgregarPreguntasAViaje < ActiveRecord::Migration[5.0]
  def change
    add_reference :questions, :trip, index: true
  end
end

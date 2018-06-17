class RelacionesScore < ActiveRecord::Migration[5.0]
  def change
  	add_reference :scores, :calificado, index:true
  	add_reference :scores, :creador, index:true
  end
end

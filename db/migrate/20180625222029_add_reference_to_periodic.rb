class AddReferenceToPeriodic < ActiveRecord::Migration[5.0]
  def change
  	    add_reference :periodics, :trip, index:true
  end
end

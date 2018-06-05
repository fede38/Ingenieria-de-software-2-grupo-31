class AddPilotoToViajes < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :viaje, index:true
  end
end

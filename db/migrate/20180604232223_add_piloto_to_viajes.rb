class AddPilotoToViajes < ActiveRecord::Migration[5.0]
  def change
    add_reference :trips, :user, index:true
  end
end

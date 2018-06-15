class AddIdViajeAVehiculo < ActiveRecord::Migration[5.0]
  def change
    add_reference :trips, :vehicle, index:true
  end
end

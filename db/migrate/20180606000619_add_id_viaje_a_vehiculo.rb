class AddIdViajeAVehiculo < ActiveRecord::Migration[5.0]
  def change
    add_reference :vehicles, :viaje, index:true
  end
end

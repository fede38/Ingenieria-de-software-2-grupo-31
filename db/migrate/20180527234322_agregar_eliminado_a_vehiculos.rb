class AgregarEliminadoAVehiculos < ActiveRecord::Migration[5.0]
	def change
		add_column(:vehicles, :eliminado, :boolean, default: false)
	end
end

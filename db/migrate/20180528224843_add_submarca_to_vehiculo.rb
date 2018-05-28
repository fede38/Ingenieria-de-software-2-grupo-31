class AddSubmarcaToVehiculo < ActiveRecord::Migration[5.0]
	def change
		add_column(:vehicles, :subMarca, :string)
	end
end

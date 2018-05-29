class AddSubmarcaToVehiculo < ActiveRecord::Migration[5.0]
	def change
		add_column(:vehicles, :sub_marca, :string)
	end
end

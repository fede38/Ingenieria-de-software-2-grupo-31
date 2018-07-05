class AddDeudaToEmbarkment < ActiveRecord::Migration[5.0]
  def change
  	add_column :embarkments, :deuda, :float, default: 0
  end
end

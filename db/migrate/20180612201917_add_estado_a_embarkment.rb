class AddEstadoAEmbarkment < ActiveRecord::Migration[5.0]
  def change
    add_column :embarkments, :estado, :string, default: 'p'
  end
end

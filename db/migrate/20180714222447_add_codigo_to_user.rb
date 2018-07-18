class AddCodigoToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :codigoSeguridad, :integer
  end
end

class AddCodigoToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :codigo_seguridad, :string
  end
end
